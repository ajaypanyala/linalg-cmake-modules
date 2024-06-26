#
# This module will locate the Fortran standard libraries so that a Fortran
# object or library can be linked against using a C/C++ compiler.
#
# After calling this module the following will be set:
#    STANDARDFORTRAN_LIBRARIES : A list of libraries to link against
#    StandardFortran_FOUND     : True if we found the standard Fortran libraries
#
# Implemenation note.  CMake provides a variable
# CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES which is a list of all libraries a
# compiler implicitly links against.  Unfortunately, at least for GNU, this
# list includes a lot of extra libraries that we don't necessarily want to
# link against (including both static and shared versions of libgcc).  This is
# why we've hardcoded the list per compiler.
#
enable_language(Fortran)
include(FindPackageHandleStandardArgs)

if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
    set(STANDARDFORTRAN_LIBS gfortran)
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
    set(STANDARDFORTRAN_LIBS ifcore)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "LLVMFlang")
    set(STANDARDFORTRAN_LIBS FortranRuntime FortranDecimal)
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Flang")
    set(STANDARDFORTRAN_LIBS flang flangrti pgmath)
    #CMAKE_Fortran_COMPILER_ID does not give "ArmFlang"
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
        set(STANDARDFORTRAN_LIBS armflang amath_a64fx)
    endif()
else()
    message(FATAL_ERROR "${CMAKE_Fortran_COMPILER_ID} is not yet supported by this module.")
endif()

foreach(STANDARDFORTRAN_LIB ${STANDARDFORTRAN_LIBS})
    set(STANDARDFORTRAN_LIB_NAMES
            lib${STANDARDFORTRAN_LIB}${CMAKE_SHARED_LIBRARY_SUFFIX} lib${STANDARDFORTRAN_LIB}.a)
    find_library(${STANDARDFORTRAN_LIB}_LIBRARY
                 ${STANDARDFORTRAN_LIB_NAMES}
                 HINTS ${CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES}
            )
    list(APPEND STANDARDFORTRAN_LIBRARIES ${${STANDARDFORTRAN_LIB}_LIBRARY})
endforeach()

find_package_handle_standard_args(StandardFortran DEFAULT_MSG
                                                      STANDARDFORTRAN_LIBRARIES)
set(STANDARDFORTRAN_FOUND ${StandardFortran_FOUND})
