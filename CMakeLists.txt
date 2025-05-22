cmake_minimum_required(VERSION 3.15)

set(OUTPUT_PATH "${CMAKE_SOURCE_DIR}/out" CACHE PATH "Location of built dlls/libraries")
set(INSTALL_PATH "${CMAKE_SOURCE_DIR}/pbproj" CACHE PATH "Location where the resulting DLL shall be placed in")
set(PBNI_SDK_DIRECTORY "C:/Program Files (x86)/Appeon/PowerBuilder 22.0/SDK/PBNI" CACHE PATH "Location of the required PBNI Sources")
set(VERSION_STR "0.0.0-trunk" CACHE STRING "Version number to add to the DLL")
set(COMPANY_NAME "Informaticon AG" CACHE STRING "")


project(°°°PACKAGE_NAME°°° LANGUAGES CXX)

add_library(${PROJECT_NAME} SHARED
	°°°SOURCE_FILES°°°
)

set_target_properties(${PROJECT_NAME}
PROPERTIES
	OUTPUT_NAME ${PROJECT_NAME}
	RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_PATH}
	ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_PATH}
	LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_PATH}
)

string(TIMESTAMP BUILD_NR "%Y,%m,%d,%H%M")
target_compile_definitions(${PROJECT_NAME}
PUBLIC
	VER_BUILD_NR=${BUILD_NR}
	VER_COMPANY_STR="${COMPANY_NAME}"
	VER_NAME_STR="${PROJECT_NAME}"
	VER_VERSION_STR="${VERSION_STR}"
)
target_sources(${PROJECT_NAME} PRIVATE res/version.rc)

find_package(lib.cpp.base.pbni-framework REQUIRED)

target_link_libraries(${PROJECT_NAME}
PRIVATE
	lib.cpp.base.pbni-framework::lib.cpp.base.pbni-framework
)

target_include_directories(${PROJECT_NAME} PUBLIC ${PBNI_SDK_DIRECTORY}/include)
target_precompile_headers(${PROJECT_NAME} PRIVATE "<PBNIFramework/pch.h>")

if (NOT INSTALL_PATH STREQUAL "")
	install(TARGETS ${PROJECT_NAME}
		RUNTIME DESTINATION ${INSTALL_PATH}
	)
endif()
