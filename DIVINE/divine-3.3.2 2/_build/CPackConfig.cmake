# This file will be configured to contain variables for CPack. These variables
# should be set in the CMake list file of the project before CPack module is
# included. The list of available CPACK_xxx variables and their associated
# documentation may be obtained using
#  cpack --help-variable-list
#
# Some variables are common to all generators (e.g. CPACK_PACKAGE_NAME)
# and some are specific to a generator
# (e.g. CPACK_NSIS_EXTRA_INSTALL_COMMANDS). The generator specific variables
# usually begin with CPACK_<GENNAME>_xxxx.


SET(CPACK_BINARY_7Z "")
SET(CPACK_BINARY_BUNDLE "OFF")
SET(CPACK_BINARY_CYGWIN "")
SET(CPACK_BINARY_DEB "OFF")
SET(CPACK_BINARY_DRAGNDROP "OFF")
SET(CPACK_BINARY_IFW "OFF")
SET(CPACK_BINARY_NSIS "OFF")
SET(CPACK_BINARY_OSXX11 "OFF")
SET(CPACK_BINARY_PACKAGEMAKER "OFF")
SET(CPACK_BINARY_RPM "OFF")
SET(CPACK_BINARY_STGZ "ON")
SET(CPACK_BINARY_TBZ2 "OFF")
SET(CPACK_BINARY_TGZ "ON")
SET(CPACK_BINARY_TXZ "OFF")
SET(CPACK_BINARY_TZ "")
SET(CPACK_BINARY_WIX "")
SET(CPACK_BINARY_ZIP "")
SET(CPACK_CMAKE_GENERATOR "Unix Makefiles")
SET(CPACK_COMPONENTS_ALL "console_tools;gui_tools;divine_dev;qt;sys;examples;help")
SET(CPACK_COMPONENTS_ALL_SET_BY_USER "TRUE")
SET(CPACK_COMPONENT_UNSPECIFIED_HIDDEN "TRUE")
SET(CPACK_COMPONENT_UNSPECIFIED_REQUIRED "TRUE")
SET(CPACK_GENERATOR "STGZ;TGZ")
SET(CPACK_INSTALL_CMAKE_PROJECTS "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build;divine;ALL;/")
SET(CPACK_INSTALL_PREFIX "/usr/local")
SET(CPACK_MODULE_PATH "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/cmake")
SET(CPACK_NSIS_DISPLAY_NAME "DIVINE 3.3.2")
SET(CPACK_NSIS_INSTALLER_ICON_CODE "")
SET(CPACK_NSIS_INSTALLER_MUI_ICON_CODE "")
SET(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
SET(CPACK_NSIS_PACKAGE_NAME "DIVINE 3.3.2")
SET(CPACK_OSX_SYSROOT "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk")
SET(CPACK_OUTPUT_CONFIG_FILE "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CPackConfig.cmake")
SET(CPACK_PACKAGE_DEFAULT_LOCATION "/")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/README")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "DiViNE Distributed and Parallel Verification Environment")
SET(CPACK_PACKAGE_FILE_NAME "divine-3.3.2-Darwin")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "DIVINE 3.3.2")
SET(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "DIVINE 3.3.2")
SET(CPACK_PACKAGE_NAME "divine")
SET(CPACK_PACKAGE_RELOCATABLE "true")
SET(CPACK_PACKAGE_VENDOR "ParaDiSe Laboratory")
SET(CPACK_PACKAGE_VERSION "3.3.2")
SET(CPACK_PACKAGE_VERSION_MAJOR "3")
SET(CPACK_PACKAGE_VERSION_MINOR "3")
SET(CPACK_PACKAGE_VERSION_PATCH "2")
SET(CPACK_RESOURCE_FILE_LICENSE "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/COPYING")
SET(CPACK_RESOURCE_FILE_README "/usr/local/Cellar/cmake/3.5.1/share/cmake/Templates/CPack.GenericDescription.txt")
SET(CPACK_RESOURCE_FILE_WELCOME "/usr/local/Cellar/cmake/3.5.1/share/cmake/Templates/CPack.GenericWelcome.txt")
SET(CPACK_SET_DESTDIR "OFF")
SET(CPACK_SOURCE_7Z "")
SET(CPACK_SOURCE_CYGWIN "")
SET(CPACK_SOURCE_GENERATOR "TBZ2;TGZ;TXZ;TZ")
SET(CPACK_SOURCE_IGNORE_FILES "/build/;/_build/;/_darcs/;~$;")
SET(CPACK_SOURCE_OUTPUT_CONFIG_FILE "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CPackSourceConfig.cmake")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "divine-3.3.2")
SET(CPACK_SOURCE_TBZ2 "ON")
SET(CPACK_SOURCE_TGZ "ON")
SET(CPACK_SOURCE_TXZ "ON")
SET(CPACK_SOURCE_TZ "ON")
SET(CPACK_SOURCE_ZIP "OFF")
SET(CPACK_SYSTEM_NAME "Darwin")
SET(CPACK_TOPLEVEL_TAG "Darwin")
SET(CPACK_WIX_SIZEOF_VOID_P "8")

if(NOT CPACK_PROPERTIES_FILE)
  set(CPACK_PROPERTIES_FILE "/Users/rcambier/Dropbox/Q8/Verification/DIVINE/divine-3.3.2 2/_build/CPackProperties.cmake")
endif()

if(EXISTS ${CPACK_PROPERTIES_FILE})
  include(${CPACK_PROPERTIES_FILE})
endif()

# Configuration for component group "tools"
set(CPACK_COMPONENT_GROUP_TOOLS_DISPLAY_NAME "Tools")
set(CPACK_COMPONENT_GROUP_TOOLS_DESCRIPTION "Installs the basic tools")
set(CPACK_COMPONENT_GROUP_TOOLS_EXPANDED TRUE)

# Configuration for component group "devel"
set(CPACK_COMPONENT_GROUP_DEVEL_DISPLAY_NAME "Development")
set(CPACK_COMPONENT_GROUP_DEVEL_DESCRIPTION "Installs header and library files")
set(CPACK_COMPONENT_GROUP_DEVEL_EXPANDED TRUE)

# Configuration for component "console_tools"
set(CPACK_COMPONENT_CONSOLE_TOOLS_DISPLAY_NAME "Console Tools")
set(CPACK_COMPONENT_CONSOLE_TOOLS_DESCRIPTION "Console tools")
set(CPACK_COMPONENT_CONSOLE_TOOLS_GROUP tools)

# Configuration for component "gui_tools"
set(CPACK_COMPONENT_GUI_TOOLS_DISPLAY_NAME "IDE")
set(CPACK_COMPONENT_GUI_TOOLS_DESCRIPTION "Graphical environment")
set(CPACK_COMPONENT_GUI_TOOLS_GROUP tools)

# Configuration for component "help"
set(CPACK_COMPONENT_HELP_DEPENDS gui_tools)
set(CPACK_COMPONENT_HELP_HIDDEN TRUE)

# Configuration for component "qt"
set(CPACK_COMPONENT_QT_DEPENDS gui_tools)
set(CPACK_COMPONENT_QT_HIDDEN TRUE)

# Configuration for component "sys"
set(CPACK_COMPONENT_SYS_HIDDEN TRUE)

# Configuration for component "examples"
set(CPACK_COMPONENT_EXAMPLES_DISPLAY_NAME "Examples")
set(CPACK_COMPONENT_EXAMPLES_DESCRIPTION "Sample models")
