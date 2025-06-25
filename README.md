# div.cpp.base.pbni-extension-template

Template for creating PBNI Extensions

## Prerequisites

* Appeon PowerBuilder
* Conann (version 2)
* CMake
* Visual Studio (MSBuild)

## What needs changing

The project name is the package name according to the informaticon universal naming convention (e.g. lib.pbni.base.mail-client).

- Replace the `°°°PACKAGE_NAME°°°` in `CMakeLists.txt` with the name of your project
- Create your sourcefiles at `src/` and add them to `CMakeLists.txt` in the `add_library` function (replace `°°°SOURCE_FILES°°°` with them).

## Quick Start

If you have GNU Make, you may just run `make build` after modifying CMakeLists.txt.

## Build instructions

### Set up an environment

If PowerBuilder is not installed in the default path (`C:/Program Files (x86)/Appeon`), you must set an environment variable `PB_DIRECTORY` that points to the corresponding directory.

If this is your first time building a PBNI Extension, [install conan](https://docs.conan.io/2/installation.html) (version 2!) and add our conan repository to be able to install the PBNI Framework:
```ps1
conan remote add inf-conan https://artifactory.informaticon.com/artifactory/api/conan/conan
```

We use this conan profile:
```ini
# %userprofile%/.conan2/profiles/pbni_x86
[settings]

# change arch to x86_64 for 64bit builds
arch=x86

build_type=MinSizeRel
compiler=msvc
compiler.cppstd=20
compiler.runtime=static
compiler.version=194
os=Windows

[options]
# change pb_version to 25.0 to use PowerBuilder 25
*:pb_version=22.0
```

## Configure

Install the dependencies and configure the CMake project:
```ps1
conan install . -pr pbni_x86 --build=missing
cmake --preset conan-default
 
```

Then you can open `build/${YOUR_PROJECT_NAME}.sln` using Visual Studio

## Build

Quickest way to build is this:
```ps1
conan build . -pr pbni_x86 -b missing
```

During development you should [configure](#configuring) for build_type=Debug.
```ps1
conan install . -pr pbni_x86  --build=missing --settings build_type=Debug
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
