# div.cpp.base.pbni-extension-template

Template for creating PBNI Extensions

## Prerequisites

* Appeon PowerBuilder
* Visual Studio (MSBuild)
* CMake
* Conan (version 2)

## Quick Start

### Setup Conan

If PowerBuilder is not installed in the default path (`C:/Program Files (x86)/Appeon`), you must set an environment variable `PB_DIRECTORY` that points to the corresponding directory.

[Install conan](https://docs.conan.io/2/installation.html) (version 2!) and add our conan repository to be able to install the PBNI Framework.
You must also detect the conan environment after it is freshly installed.

```ps1
conan remote add inf-conan https://artifactory.informaticon.com/artifactory/api/conan/conan

conan profile detect
```

Change the default Conan profile (usually found at `%userprofile%/.conan2/profiles/default`).
This profile tells Conan to build for a 32-bit architecture and specifies compiler settings.
```ini
# %userprofile%/.conan2/profiles/default
[settings]
# Do not change these values, they werde detrmined by conan profile detect and are probably correct
compiler=msvc
compiler.version=194
os=Windows

# Change arch to x86.
# If you need a 64bit build, you can set it to x86_64.
arch=x86

# Change build_type to MinSizeRel (produces smaller DLL files than Release).
# If you want to debug you C++ code when it is called from a PB app, change it to Debug.
build_type=MinSizeRel

# Change compiler.runtime to static linking.
compiler.runtime=static

# PBNI Framework needs compiler.cppstd 20.
compiler.cppstd=20

# This option has to be set for PBNI Framework.
[options]
# Set *:pb_version to 22.0 for PowerBuilder 2022
# or 25.0 for PowerBuilder 2025
*:pb_version=22.0
```

### Code the extension

With your environment configured, you can now build the extension.
For Informaticon projects, the project name is the package name according to the informaticon universal naming convention (e.g. lib.pbni.base.mail-client).
Otherwise you are free to choose any project name.

Modify the project for your needs / program your library:

* Replace `°°°PACKAGE_NAME°°°` in `CMakeLists.txt` with the name of your project.
* Create your sourcefiles at `src/` and add them to `CMakeLists.txt` in the `add_library` function (replace `°°°SOURCE_FILES°°°` with them).

Example:

* CMakeLists.txt
```CMake
add_library(${PROJECT_NAME} SHARED
	src/arithmetic.cpp
	src/arithmetic.h
)
```

* arithmetic.h
```cpp
namespace Inf {
    class arithmetic : public PBNI_Class {
    public:
        PBInt f_add(PBInt, PBInt);
    };
}
```

* arithmetic.cpp
```cpp
#include "arithmetic.h"

namespace Inf {
    INF_REGISTER_CLASS(arithmetic, L"u_pbni_arithmetic");

    INF_REGISTER_FUNC(f_add, L"of_add", L"ai_left", L"ai_right");
    PBInt arithmetic::f_add(PBInt arg0, PBInt arg1) {
        return arg0 + arg1;
    }
}
```

### Build the extension

With your environment configured, you can now build the extension.

Install the required dependencies using Conan. This may take some time on the first run as it downloads and builds the necessary libraries.

```ps1
conan install . --build=missing
```

Generate the Visual Studio project files using CMake.
After that step, you can open the PBNI extension project in Visual Studio (`build/${YOUR_PROJECT_NAME}.sln`).

```ps1
cmake --preset conan-default
```

Build the PBNI extension.

```ps1
conan build . --build=missing
```

### Use the extension in PowerBuilder

Add the Informaticon Exception Framework to you project:
* Download the latest release from [Github](https://github.com/informaticon/pb-exception-framework/releases/) (e.g. lib.pb.base.exception-framework@1.2.3+pb22-x86-minsizerel.zip for PB2022R3).
* Unzip exf1.dll and exf1.pbl into you PowerBuilder project folder.
* Add exf1.pbl to your library list.
* Integrate exception framework in the application object:

```powerbuilder
// Global variables
u_exf_error_manager gu_e

// open() event
gu_e = create u_exf_error_manager

// systemerror() event
gu_e.of_display(gu_e.of_new_error() &
	.of_set_nested_error(gu_e.of_get_last_error()) &
	.of_push(1 /*populateerror()-Return*/) &
	.of_set_message('systemerror occured') &cc
	.of_push('Notice', 'Nested error may be unrelated to this system error.') &
	.of_set_type('u_exf_re_systemerror'))
halt
```

Finally, import the resulting DLL file into PowerBuilder.
You can find it in the build directory, for example: `./build/Debug/div.cpp.base.pbni-framework-usage-example.dll`.

## Further reading

* PBNI Framework: [cpp-pbni-framework (OSS)](https://github.com/informaticon/cpp-pbni-framework) / [lib.cpp.base.pbni-framework (Informaticon)](https://github.com/informaticon/lib.cpp.base.pbni-framework)
* More examples: [div.cpp.base.pbni-framework-usage-example](https://github.com/informaticon/div.cpp.base.pbni-framework-usage-example).
