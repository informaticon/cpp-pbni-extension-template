 div.cpp.base.pbni-extension-template

Template for creating PowerBuilder Libraries that use the PowerBuilder Native Interface (in this case using the [Informaticon PBNI Framework](/informaticon/cpp-pbni-framework)).

This library uses the name `pbni-extension-template` and abbreviation `tpl` in a few places (inside files as well as filenames), you should probably replace them with your library names.

## Prerequisites

* Appeon PowerBuilder
* Visual Studio (MSBuild)
* CMake
* Conan (version 2)

## TLDR
Develop in C++ in [pbni/src](pbni/src) then build the changes with.
```ps1
conan build pbni -pr pbni_x86
```

Then open the PowerBuilder project [tpb.pbsln](tpb.pbsln).
If you added a class / method you need to reimport the dll into `tpl1.pbl` by right clicking, then `Import PB Extension...`.

Code your PowerBuilder stuff and Run.


## Project Structure
### tpl.pbl/
This is where the PowerBuilder code for your library goes, any utility functions or wrappers will are put here.
The pbni classes will also be put in here. This is the only folder that should be shipped in a release (plus the dll).

### pbni/
This folder contains the C++ project.

### test/
Put any test code in here. You will also need to add the exception framework in here.

### pbni-extension-template.dll
The built DLL.

---

## PBNI Development

### Setup

Get the Informaticon Exception Framework:
<details open>
  <summary>For Informaticon projects</summary>

  ```pwsh
  axp fetch
  ```
</details>
<details>
  <summary>For external project</summary>

  * Download the latest release from [Github](https://github.com/informaticon/pb-exception-framework/releases/) (e.g. lib.pb.base.exception-framework@1.2.3+pb22-x86-minsizerel.zip for PB2022R3).
  * Unzip exf1.dll and exf1.pbl into the `test/` folder.
</details>


If you have not already, add our build cache to conan (to get faster builds and the PBNI Framework recipe).
```ps1
conan remote add inf-conan https://artifactory.informaticon.com/artifactory/api/conan/conan
```

If you want to use the cached files you need to use these conan profiles:

For development:
```ini
# ~/.conan2/profiles/pbni_x86
[settings]
arch=x86
build_type=Debug
compiler=msvc
compiler.cppstd=20
compiler.runtime=static
compiler.version=194
os=Windows

[options]
*:pb_version=22.0
```

For Releases:
```ini
# ~/.conan2/profiles/pbni_x86_minsizerel
[settings]
arch=x86
build_type=MinsizeRel
compiler=msvc
compiler.cppstd=20
compiler.runtime=static
compiler.version=194
os=Windows

[options]
*:pb_version=25.0
```

If you only use Conan for PBNI development, you can copy / symlink the pbni_x86 config to `~/.conan2/profiles/default`, then you don't need to pass the profile to each conan command.

If PowerBuilder is not installed in the default path (`C:/Program Files (x86)/Appeon`), you must set an environment variable `PB_DIRECTORY` that points to the corresponding directory.


### Building
```ps1
conan build pbni -pr pbni_x86_minsizerel -b missing
```

### Developing
```ps1
cd pbni
conan install -pr pbni_x86 -b missing
cmake --preset conan-default
```

After that, you can open the PBNI extension project in Visual Studio (`pbni/build/${YOUR_PROJECT_NAME}.sln`).
In Visual Studio make sure to build the Install target

```ps1
cmake --build --preset conan-debug -t install
```
The `-t install` argument will make cmake install the dll in the root of this project (next to this Readme).

You shouldn't run the Install target while the PowerBuilder Application is currently running, Since you will get weird Errors telling you that you don't have Permissions to overwrite the DLL.

#### Creating new Source Files
When creating new files, they have to be created in the `src/` directory, this means that you shouldn't create new Files in Visual Studio, since those would be created inside the build directory.
Once you've created the Source File, you need to update the CMake project, to do that you have to do one of:
- In Terminal: `cmake pbni --preset conan-default`
- In Visual Studio: build `ZERO_CHECK`
- In VSCode: `CMake: Configure`

#### Docs
You can find the PBNI Framework docs [here](https://github.com/informaticon/cpp-pbni-framework)

#### Debugging
To attach to PowerBuilder, open the PowerBuidler IDE and then inside Visual Studio go to `Debug > Attach to Process... (Ctrl+Alt+P)` and choose the PBXXX.exe process you want (XXX being the PowerBuilder version).

#### External Libraries
You can just add the dependency in `conanfile.py`:
```py
class Recipe(ConanFile):
    requires = [
        "lib.cpp.base.pbni-framework/0.1.2",
        "poco/1.13.3",
    ]
```
then run this inside the pbni dir to update the lockfile:
```ps1
conan lock create . -pr pbni_x86 -b missing
```

After installing the package, you need to add it to the [CMakeLists.txt](pbni/CMakeLists.txt) file. To do this, go to the very bottom of the file, where you should see a `target_link_libraries` option. Before that line, import the package using `find_package`, and then add the packages name to the `target_link_library` option. Heres an example of how to add Pocos JSON Parser. 
```cmake
find_package(lib.cpp.base.pbni-framework REQUIRED)
find_package(Poco REQUIRED JSON)

target_link_libraries(libMailClient
PRIVATE
	lib.cpp.base.pbni-framework::lib.cpp.base.pbni-framework
	Poco::JSON
)
```

#### Local Libraries
If you want to add a local library, you need 2 things, a static `.lib` file. and an `include/` folder. If you are not sure which ones you need, ask Simon Jutzi or Micha Wehrli.

Once you've gathered your required files. Create a Subfolder in the `pbni/extern/` folder and setup your folders like so:
```
pbni/
├── extern/
│   └── your.library.name/
│       ├── lib/
│       │   └── your-library.lib
│       ├── include/
│       │   ├──  some_header.h
│       │   └──  another_header.h
│       └── CMakeLists.txt
├── ...
└── CMakeLists.txt
```

Put your `.lib` file into the lib/ subfolder and the contents of your `include/` folder into the `include/` subfolder. Then Create the `CMakeLists.txt` file on the same level as the `lib/` and `include/` folders. Inside it add:
```cmake
# extern/your.library.name/CMakeLists.txt
CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

add_library(libYours STATIC IMPORTED GLOBAL)

set_target_properties(libYours
PROPERTIES
	IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/lib/your-library.lib
)

target_include_directories(libYours
INTERFACE
	${CMAKE_CURRENT_SOURCE_DIR}/include
)
```
You should replace the `libYours` with a suitable name and put the correct `.lib` file name.

And finally in the topmost [CMakeLists.txt](pbni/CMakeLists.txt), add the `add_subdirectory` and your library to the  `target_link_libraries` option:
```cmake
...

add_subdirectory(extern/your.library.name)
find_package(lib.cpp.base.pbni-framework REQUIRED)

target_link_libraries(${PROJECT_NAME}
PRIVATE
	lib.cpp.base.pbni-framework::lib.cpp.base.pbni-framework
    libYours
)
```

### Importing
Open the Project in PowerBuilder and right click on `tpl.pbl`, choose `Import PB Extension...` and select the dll (e.g. ./pbni-extension-template.dll).
This will create stub classes for all classes that you registered with `INF_REGISTER_CLASS`.

### Releasing
Informaticon Projects can just create and push a tag on the commit that they want to create a Release on. (Make sure the commit has a good commit message, because that message will be used as the releases description). A Github Workflow will rebuild the PBNI project with `build_type=MinSizeRel` for both PowerBuilder 22 and 25, then it will create a release to the package service.

### VSCode
While it is recommended to use Visual Studio and PowerBuilder as development IDEs, VSCode is also supported.
To make it work nicely with AutoCompletion and building you need these extensions:
 - [C/C++ Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack)
 - [Tasks Shell Input](https://marketplace.visualstudio.com/items?itemName=augustocdias.tasks-shell-input)

Even when using VSCode you still need to install Visual Studio to get the build tools.

#### Developing
You do not need to run the cmake commands, just open the directory containing this Readme in VSCode and install dependencies:
```ps1
conan install -pr pbni_x86 -b missing
```
After that open Command Pallete (Ctrl+Shift+P) and run `CMake: Configure`, if it asks choose the `conan-default` preset.

#### Building
Then you can also build with `CMake: Build` or `CMake: Install`.

#### Debugging
There is a [launch.json](.vscode/launch.json) setup to attach to PowerBuilder. So hitting `<F5>` should be enough.
You will need to stop the Debugging Session when rebuilding the DLL.


## Further reading

* PBNI Framework: [cpp-pbni-framework (OSS)](https://github.com/informaticon/cpp-pbni-framework) / [lib.cpp.base.pbni-framework (Informaticon)](https://github.com/informaticon/lib.cpp.base.pbni-framework)
* More examples: [div.cpp.base.pbni-framework-usage-example](https://github.com/informaticon/div.cpp.base.pbni-framework-usage-example).