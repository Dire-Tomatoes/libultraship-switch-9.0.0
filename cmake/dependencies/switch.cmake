#=================== ImGui ===================
find_package(SDL2 REQUIRED)
target_link_libraries(ImGui PUBLIC SDL2::SDL2)

# glad and EGL are provided by devkitPro portlibs
find_library(GLAD_LIBRARY glad HINTS "${DEVKITPRO}/portlibs/switch/lib")
find_library(EGL_LIBRARY EGL HINTS "${DEVKITPRO}/portlibs/switch/lib")
target_link_libraries(ImGui PUBLIC ${GLAD_LIBRARY})

# Switch uses glad (not GLEW) for GL loading.
# IMGUI_IMPL_OPENGL_LOADER_CUSTOM skips ImGui's built-in loader (which needs dlopen/dlsym).
# Force-include glad/glad.h so ImGui still gets GL type/function declarations.
target_compile_definitions(ImGui PRIVATE IMGUI_IMPL_OPENGL_LOADER_CUSTOM IMGUI_DISABLE_DEFAULT_SHELL_FUNCTIONS)
target_compile_options(ImGui PRIVATE -include glad/glad.h)

target_include_directories(ImGui PRIVATE ${DEVKITPRO}/portlibs/switch/include)

include(FetchContent)

#=================== tinyxml2 ===================
# devkitpro's switch-tinyxml2 (6.0.0) exports tinyxml2_static, not tinyxml2::tinyxml2.
# FetchContent 10.0.0 to match the target name LUS expects.
set(tinyxml2_BUILD_TESTING OFF)
FetchContent_Declare(
    tinyxml2
    GIT_REPOSITORY https://github.com/leethomason/tinyxml2.git
    GIT_TAG 10.0.0
    OVERRIDE_FIND_PACKAGE
)
FetchContent_MakeAvailable(tinyxml2)

#=================== spdlog ===================
# Switch newlib under -std=c++20 defines __STRICT_ANSI__, hiding POSIX functions
# (fileno, fsync, etc.) that spdlog uses. _POSIX_C_SOURCE re-exposes them.
# SPDLOG_PREVENT_CHILD_FD skips fcntl(FD_CLOEXEC) which Switch doesn't support.
add_compile_definitions(SPDLOG_PREVENT_CHILD_FD)

find_package(spdlog QUIET)
if (NOT ${spdlog_FOUND})
    FetchContent_Declare(
        spdlog
        GIT_REPOSITORY https://github.com/gabime/spdlog.git
        GIT_TAG v1.14.1
        OVERRIDE_FIND_PACKAGE
    )
    FetchContent_MakeAvailable(spdlog)
    target_compile_definitions(spdlog PRIVATE _POSIX_C_SOURCE=200809L)
endif()

#=================== StormLib ===================
if(NOT EXCLUDE_MPQ_SUPPORT)
    target_compile_definitions(storm PRIVATE -D_POSIX_C_SOURCE=200809L)
endif()
