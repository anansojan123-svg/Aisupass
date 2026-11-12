cmake_minimum_required(VERSION 3.22.1)

# 目标名不带扩展名：产物名由 PREFIX/SUFFIX 组合成 libghostlock.so。
# AGP 只打包 lib*.so，且必须先落进 CMAKE_LIBRARY_OUTPUT_DIRECTORY。
project(cve43499)

# 上游编译参数（逐字来自 .bin/ghostlock-app/src/Makefile:62-67）：
#   CXXFLAGS = -O2 -flto -Wall -Wextra -Wconversion -Wsign-conversion
#              -Wno-unused-parameter -Wno-sign-compare -Wno-unused-function
#              -Icore -DTARGET_CONFIG_H="kernel/target.h"
#              -std=c++23 -fno-rtti
#   LDFLAGS  = -fPIE -pie -pthread -flto -static-libstdc++
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(ghostlock
    main.cpp
    attack/ops.cpp
    profile/entry.cpp
    profile/binary.cpp
    memory/address_space.cpp
    memory/heap_context.cpp
    memory/payload_builder.cpp
    race/pi_race.cpp
    race/threads.cpp
    route/route_controller.cpp
    route/route_middleware.cpp
    route/tcp_zerocopy_route.cpp
    route/select_stack_route.cpp
    route/multicast_waiter_route.cpp
    session/runtime_config.cpp
    session/exploit_session.cpp
    session/backend/cve_2026_43499_backend.cpp
    session/root_child_frontend.cpp
    session/handoff_probe.cpp
    session/victim_process.cpp
    session/victim_context.cpp
    support/util.cpp
    support/native_resource.cpp
    support/run_state.cpp
)

set_target_properties(ghostlock PROPERTIES
    PREFIX "lib"
    SUFFIX ".so"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}"
)

# include 根是 jni/cve43499 本身（上游是 -Icore，core 即源码根）。
target_include_directories(ghostlock PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# 取值必须带双引号：源码里是 #include TARGET_CONFIG_H。
target_compile_definitions(ghostlock PRIVATE
    "TARGET_CONFIG_H=\"kernel/target.h\""
)

target_compile_options(ghostlock PRIVATE
    -O2
    -fPIE
    -fno-rtti
    -flto
    -Wall
    -Wextra
    -Wconversion
    -Wsign-conversion
    -Wno-unused-parameter
    -Wno-sign-compare
    -Wno-unused-function
)

target_link_options(ghostlock PRIVATE
    -flto
    -pie
    -pthread
    # Android 15+ 16KB 页设备要求 ELF LOAD 段 16KB 对齐，否则安装被拒。
    -Wl,-z,max-page-size=16384
    -Wl,-z,common-page-size=16384
)
