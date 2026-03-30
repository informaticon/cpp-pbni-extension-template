cmake_minimum_required(VERSION 3.15)

# Environment and build settings
################################

project(pbni-extension-template LANGUAGES CXX)

set(INSTALL_PATH "${CMAKE_SOURCE_DIR}/.." CACHE PATH "Location where the resulting DLL shall be placed in")
set(PBNI_SDK_DIRECTORY "C:/Program Files (x86)/Appeon/PowerBuilder 25.0/SDK/PBNI" CACHE PATH "Location of the required PBNI Sources")
set(VERSION_STR "0.0.0-trunk" CACHE STRING "Version number to add to the DLL")
set(COMPANY_NAME "Informaticon AG" CACHE STRING "")

# Build script
##############

file(GLOB SOURCE src/*.cpp src/*.h)
add_library(${PROJECT_NAME} SHARED ${SOURCE})

string(TIMESTAMP BUILD_NR "%Y,%m,%d,%H%M")
target_compile_definitions(${PROJECT_NAME}
PUBLIC
	VER_BUILD_NR=${BUILD_NR}
	VER_COMPANY_STR="${COMPANY_NAME}"
	VER_NAME_STR="${PROJECT_NAME}"
	VER_VERSION_STR="${VERSION_STR}"
)

target_sources(${PROJECT_NAME} PRIVATE res/version.rc)
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_20)

find_package(lib.cpp.base.pbni-framework REQUIRED)

target_link_libraries(${PROJECT_NAME}
PRIVATE
	lib.cpp.base.pbni-framework::lib.cpp.base.pbni-framework
)

target_include_directories(${PROJECT_NAME} PUBLIC ${PBNI_SDK_DIRECTORY}/include)
target_precompile_headers(${PROJECT_NAME} PRIVATE "<PBNIFramework/pch.h>")


# Install
#########

if (NOT INSTALL_PATH STREQUAL "")
	install(TARGETS ${PROJECT_NAME}
		RUNTIME DESTINATION ${INSTALL_PATH}
	)
endif()
