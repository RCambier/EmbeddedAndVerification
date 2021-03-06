find_package(Qt4 REQUIRED)
include(${QT_USE_FILE})

include_directories(${QT_INCLUDES} ${CMAKE_CURRENT_BINARY_DIR})
include_directories(qt)

set(BASE_TOOLS_SRC
    baseToolsModule.cpp
    baseToolsModule.h
    outputDock.cpp
    outputDock.h
    mscDock.cpp
    mscDock.h
    cycleBar.cpp
    cycleBar.h
    traceDock.cpp
    traceDock.h
    transitionDock.cpp
    transitionDock.h
    watchDock.cpp
    watchDock.h
    
    editorPreferences.cpp
    editorPreferences.h
    outputPreferences.cpp
    outputPreferences.h
    simulatorPreferences.cpp
    simulatorPreferences.h
)

set(BASE_TOOLS_MOC
    baseToolsModule.h
    outputDock.h
    mscDock.h
    cycleBar.h
    traceDock.h
    transitionDock.h
    watchDock.h
    
    editorPreferences.h
    outputPreferences.h
    simulatorPreferences.h
)

set(BASE_TOOLS_UI
    ui/outputPreferences.ui
    ui/editorPreferences.ui
    ui/simulatorPreferences.ui
)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/plugins)

qt4_wrap_cpp(BASE_TOOLS_SRC2 ${BASE_TOOLS_MOC})
qt4_wrap_ui(BASE_TOOLS_SRC3 ${BASE_TOOLS_UI})

add_library(baseTools STATIC ${BASE_TOOLS_SRC} ${BASE_TOOLS_SRC2} ${BASE_TOOLS_SRC3})
# target_link_libraries(baseTools baseIDE ${QT_LIBRARIES} qtcolorpicker)
