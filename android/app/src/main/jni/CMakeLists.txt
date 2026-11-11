cmake_minimum_required(VERSION 3.22.1)

project(aisupnative)

# DirtyFrag（CVE-2026-43284）：libdfroot.so + libbootstrap.so
add_subdirectory(dfroot)

# GhostKey（CVE-2026-98260）：libcve98260.so（PIE 可执行文件）
add_subdirectory(cve98260)
