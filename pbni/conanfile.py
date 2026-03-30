from conan import ConanFile
from conan.tools.cmake import CMake, cmake_layout
import os

class Recipe(ConanFile):
    requires = [
        "lib.cpp.base.pbni-framework/0.1.2",
    ]

    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps", "CMakeToolchain"

    options = { "pb_version": ["ANY"] }

    def layout(self):
        cmake_layout(self)

    def build(self):
        vars = {}

        if self.version:
            vars["VERSION_STR"] = self.version

        pbdir = os.environ.get("PB_DIRECTORY", f"C:/Program Files (x86)/Appeon")
        vars["PBNI_SDK_DIRECTORY"] = f"{pbdir}/PowerBuilder {self.options.pb_version}/SDK/PBNI/"

        cmake = CMake(self)
        cmake.configure(vars)
        cmake.build(target="install")