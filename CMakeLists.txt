cmake_minimum_required(VERSION 3.16)

project(DesktopApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick)

add_executable(DesktopApp
    main.cpp
    qml.qrc
    db.cpp
    db.h
    train.cpp
    train.h
    typewagon.h
    typewagon.cpp
    route.h
    route.cpp
)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Sql)

target_link_libraries(DesktopApp
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Sql
)
