SHELL := pwsh.exe
.SHELLFLAGS := -Command

.PHONY: build
build: configure
	conan build . -pr pbni_x86 -b missing

.PHONY: configure
configure: build/CMakeFiles

build/CMakeFiles:
	conan install . -pr pbni_x86  --build=missing
	cmake --preset conan-default

.PHONY: clean
clean:
	Remove-Item -Path "build" -Recurse -Force; exit 0
	Remove-Item -Path "out" -Recurse -Force; exit 0
	Remove-Item -Path "CMakeUserPresets.json" -Force; exit 0
	