# Install script for directory: /Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/gui/main

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "gui_tools")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/libexec/divine" TYPE DIRECTORY FILES "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/gui/divine.ide.app" USE_SOURCE_PERMISSIONS)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/divine/divine.ide.app/Contents/MacOS/divine.ide" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/divine/divine.ide.app/Contents/MacOS/divine.ide")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/divine/divine.ide.app/Contents/MacOS/divine.ide")
    execute_process(COMMAND /usr/bin/install_name_tool
      -delete_rpath "/Users/rcambier/anaconda/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/libexec/divine/divine.ide.app/Contents/MacOS/divine.ide")
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(WRITE $ENV{DESTDIR}/usr/local/bin/divine.ide "#!/bin/sh
export LD_LIBRARY_PATH='/usr/local/lib/divine':$LD_LIBRARY_PATH
export DIVINE_GUI_PLUGIN_PATH=''
export DIVINE_GUI_HELP_PATH='/usr/local/share/divine/help'
/usr/local/libexec/divine/divine.ide
") 
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  execute_process(COMMAND chmod a+x $ENV{DESTDIR}/usr/local/bin/divine.ide)
endif()

