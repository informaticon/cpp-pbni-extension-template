# div.cpp.base.pbni-extension-template

Template for creating PBNI Extensions

## What needs changing

The project name is the package name according to the informaticon universal naming convention (e.g. lib.pbni.base.mail-client).

- Replace the `°°°PACKAGE_NAME°°°` in `CMakeLists.txt` with the name of your project
- Create your sourcefiles at `src/` and add them to `CMakeLists.txt` in the `add_library` function (replace `°°°SOURCE_FILES°°°` with them).

## Setting up an environment

If this is your first time building a PBNI Extension, [install conan](https://docs.conan.io/2/installation.html) (version 2!).

You then need to add our conan Repository to be able to install the PBNI Framework:
```ps1
conan remote add inf-conan https://artifactory.informaticon.com/artifactory/api/conan/conan
```

We use this profile during development:
```ini
# %userprofile/.conan2/profiles/pbni_x86_debug
[settings]

# change arch to x86_64 for 64bit builds
arch=x86

# change build_type to MinSizeRel if you want to
build_type=Debug
compiler=msvc
compiler.cppstd=20
compiler.runtime=static
compiler.version=194
os=Windows

[options]
# change pb_version to 25.0 to use PowerBuilder 25
*:pb_version=22.0
```

## Configuring

Install the dependencies and configure the CMake project:
```ps1
conan install . -pr pbni_x86_debug -b missing
cmake --preset conan-default
```

Then you can open `build/${YOUR_PROJECT_NAME}.sln` using Visual Studio

## Building

Quickest way to build is this:
```ps1
conan build . -pr pbni_x86_debug -b missing
```

During development you should [configure](#configuring) and then you can build either using the GUI in Visual Studio or VS Code or with this command:
```ps1
cmake --build --preset conan-debug
```

## Example code

arithmetic.h
```cpp
namespace Inf {
    class arithmetic : public PBNI_Class {
    public:
        PBInt f_add(PBInt, PBInt);
    };
}
```

arithmetic.cpp
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

More examples at [div.cpp.base.pbni-framework-usage-example](https://github.com/informaticon/div.cpp.base.pbni-framework-usage-example).
