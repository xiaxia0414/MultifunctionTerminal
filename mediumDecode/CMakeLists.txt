cmake_minimum_required(VERSION 3.5)
project(mediumDecode)
aux_source_directory(./ SRC)
file(GLOB HEADERS ${CMAKE_CURRENT_SOURCE_DIR}/*.h)
file(GLOB UIS ${CMAKE_CURRENT_SOURCE_DIR}/*.ui)
add_library(mediumDecode STATIC ${SRC} ${HEADERS} ${UIS}
    audiodecoder.h audiodecoder.cpp)

target_link_libraries(mediumDecode PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Gui
Qt${QT_VERSION_MAJOR}::Multimedia avcodec avformat avutil swscale swresample )
