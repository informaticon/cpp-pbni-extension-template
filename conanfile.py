from conan import ConanFile
from conan.tools.cmake import CMake, cmake_layout


class Recipe(ConanFile):
    requires = [
        "lib.cpp.base.pbni-framework/0.1.0",
    ]

    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps", "CMakeToolchain"

    options = { "pb_version": ["ANY"] }

    def layout(self):
        cmake_layout(self)

    def build(self):
        vars = { "PBNI_SDK_DIRECTORY": f"C:/Program Files (x86)/Appeon/PowerBuilder {self.options.pb_version}/SDK/PBNI/" }
        if self.version:
            vars["VERSION_STR"] = self.version

        cmake = CMake(self)
        cmake.configure(vars)
        cmake.build()