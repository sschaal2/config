#############################################################################
#############################################################################
#
#  This is a cmake include file originally programmed for the CLMC/AMD labs
#  at the University of Southern California and the Max-Planck-Institute for
#  Intelligent Systems. We use a mixutre of explicit makefiles and cmake, but 
#  primarily we relay on cmake for all major compile dependencies. All our
#  software is provided under a slightly modified version of the LGPL license
#  to be found at http://www-clmc.usc.edu/software/license.
#
#  Copyright by Stefan Schaal, 2014
#
#############################################################################
#############################################################################
# which cmake version do we require?

cmake_minimum_required(VERSION 2.8)

# we use gcc and g++ as compiler

set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

#############################################################################
# which lab are we compiling for

exec_program(hostname ARGS "-f" OUTPUT_VARIABLE HOST_NAME)

if(${HOST_NAME} MATCHES "usc")
  set(LAB CLMC)
else ()
  set(LAB AMD)
endif()

set(MY_BINDIR $ENV{PROG_ROOT}/bin)
set(MY_INCLUDES $ENV{PROG_ROOT}/include)
set(MY_LIBDIR $ENV{PROG_ROOT}/lib/$ENV{MACHTYPE})

set(MYBINDIR ${MY_BINDIR})
set(MYINCLUDEPATH ${MY_INCLUDES})
set(MYLIBDIR ${MY_LIBDIR})

set(DOCUMENTATIONDIR doc)

set(LAB_BINDIR $ENV{LAB_ROOT}/bin/$ENV{MACHTYPE})
set(LAB_INCLUDES $ENV{LAB_ROOT}/include)
set(LAB_LIBDIR $ENV{LAB_ROOT}/lib/$ENV{MACHTYPE})

#############################################################################
# set useful variables according to MACHTYPE environment variables

# general compile flags and variables

add_definitions(-DUNIX)
add_definitions(-D${LAB})
add_definitions(-D$ENV{MACHTYPE})

set(CMAKE_C_FLAGS "-Wall -Wno-unused -Wno-strict-aliasing -Wno-deprecated-declarations ${CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "-Wall -Wno-unused -Wno-strict-aliasing -Wno-deprecated-declarations ${CMAKE_CPP_FLAGS}")

# architecture specific

if ($ENV{MACHTYPE} STREQUAL "x86_64mac")

  message("Detected MACHTYPE=x86_64mac")
  include_directories(BEFORE /opt/local/include /opt/X11/include /usr/include)
  link_directories(/opt/local/lib /opt/X11/lib /usr/lib ${CMAKE_LIBRARY_PATH})
  set(LAB_STD_LIBS edit curses glut GL GLU X11 m)

# check for problematic compiler flags
  include(CheckCCompilerFlag)

elseif ($ENV{MACHTYPE} STREQUAL "x86_64xeno" )

  message("Detected MACHTYPE=x86_64xeno")

  set(XENOMAI_ROOT /usr/xenomai)

  exec_program(${XENOMAI_ROOT}/bin/xeno-config ARGS "--skin=native --cflags" 
  						  OUTPUT_VARIABLE XENOMAI_C_FLAGS)  
  exec_program(${XENOMAI_ROOT}/bin/xeno-config ARGS "--skin=native --ldflags" 
  						  OUTPUT_VARIABLE XENOMAI_LD_FLAGS)  
  set(CMAKE_C_FLAGS "${XENOMAI_C_FLAGS} ${CMAKE_C_FLAGS}")
  set(CMAKE_CPP_FLAGS "${XENOMAI_C_FLAGS} ${CMAKE_CPP_FLAGS}")
  set(LAB_STD_LIBS native xenomai pthread rtdk analogy rtdm edit curses nsl glut GL GLU X11 Xmu m std++)

  link_directories(${XENOMAI_ROOT}/lib /usr/X11/lib64 /usr/X11/lib /usr/lib64 ${CMAKE_LIBRARY_PATH})
  include_directories(BEFORE ${XENOMAI_C_FLAGS})

else ($ENV{MACHTYPE} STREQUAL "x86_64")

  message("Detected MACHTYPE=x86_64")
  include_directories()
  link_directories(/usr/X11/lib64 /usr/X11/lib /usr/lib64 ${CMAKE_LIBRARY_PATH})
  set(LAB_STD_LIBS pthread rt edit curses nsl glut GL GLU X11 Xmu m std++)

endif()


include_directories(BEFORE ${MY_INCLUDES} ${LAB_INCLUDES})
link_directories(${MY_LIBDIR} ${LAB_LIBDIR})

#############################################################################
# set robot machine names globally

set(ARM_HOST mandy)
set(APOLLO_HOST pechstein)
set(LBR4_HOST pechstein)
set(HERMES_HOST hermes)
set(PHANTOM_HOST braque)
set(SARCOS_MASTER_HOST xenomai)
set(SARCOS_SLAVE_HOST xenomai)
set(SARCOS_PRIMUS_HOST xenomai)

#############################################################################
# print out all variables that we care about

set(_variableNames 
		   LAB
		   CMAKE_C_FLAGS 
		   CMAKE_CPP_FLAGS 
		   CMAKE_INCLUDE_PATH
		   CMAKE_LIBRARY_PATH
		   LAB_STD_LIBS
		   LAB_LIBDIR
		   MY_LIBDIR
		   LAB_INCLUDES
		   MY_INCLUDES
		   LAB_BINDIR
		   MY_BINDIR 	
		   DOCUMENTATIONDIR )

# only uncomment for debugging all cmake variables
# get_cmake_property(_variableNames VARIABLES)

foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()

#############################################################################
# add custom rules

add_custom_target(clean-all COMMAND 
			    ${CMAKE_COMMAND} -P $ENV{LAB_ROOT}/config/cmake/clean-all.cmake)


set(DOXYGEN_CMD doxygen)
set(DOXYGEN_DIR ../doc)

add_custom_target(doc COMMAND ${DOXYGEN_CMD} ${DOXYGEN_DIR}/Doxyfile) 

