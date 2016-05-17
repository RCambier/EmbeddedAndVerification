# Install script for directory: /Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/gui

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

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/gui/qtcolorpicker/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/gui/main/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/gui/baseIde/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/gui/baseTools/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/gui/dve/cmake_install.cmake")

endif()

