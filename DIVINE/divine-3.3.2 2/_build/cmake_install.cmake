# Install script for directory: /Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2

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

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "doc")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/doc/divine" TYPE FILE FILES
    "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/README"
    "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/COPYING"
    "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/AUTHORS"
    "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/NEWS"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/tbbmalloc/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/libutap/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/dbm/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/external/murphi/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/divine/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/tools/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/examples/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/gui/cmake_install.cmake")
  include("/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/test/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
