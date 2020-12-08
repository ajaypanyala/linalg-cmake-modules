if( "ilp64" IN_LIST IBMESSL_FIND_COMPONENTS AND "lp64" IN_LIST IBMESSL_FIND_COMPONENTS )
  message( FATAL_ERROR "IBMESSL cannot link to both ILP64 and LP64 iterfaces" )
endif()

set( IBMESSL_LP64_SERIAL_LIBRARY_NAME  "essl"        )
set( IBMESSL_LP64_SMP_LIBRARY_NAME     "esslsmp"     )
set( IBMESSL_ILP64_SERIAL_LIBRARY_NAME "essl6464"    )
set( IBMESSL_ILP64_SMP_LIBRARY_NAME    "esslsmp6464" )


if( NOT IBMESSL_PREFERED_THREAD_LEVEL )
  set( IBMESSL_PREFERED_THREAD_LEVEL "smp" )
endif()

if( IBMESSL_PREFERED_THREAD_LEVEL MATCHES "smp" )
  set( IBMESSL_LP64_LIBRARY_NAME  ${IBMESSL_LP64_SMP_LIBRARY_NAME}  )
  set( IBMESSL_ILP64_LIBRARY_NAME ${IBMESSL_ILP64_SMP_LIBRARY_NAME} )
else()
  set( IBMESSL_LP64_LIBRARY_NAME  ${IBMESSL_LP64_SERIAL_LIBRARY_NAME}  )
  set( IBMESSL_ILP64_LIBRARY_NAME ${IBMESSL_ILP64_SERIAL_LIBRARY_NAME} )
endif()


find_path( IBMESSL_INCLUDE_DIR
  NAMES essl.h
  HINTS ${IBMESSL_PREFIX}
  PATHS ${IBMESSL_INCLUDE_DIR}
  PATH_SUFFIXES include
  DOC "IBM(R) ESSL header"
)

find_library( IBMESSL_LP64_LIBRARIES
  NAMES ${IBMESSL_LP64_LIBRARY_NAME}
  HINTS ${IBMESSL_PREFIX}
  PATHS ${IBMESSL_LIBRARY_DIR} ${CMAKE_C_IMPLICIT_LINK_DIRECTORIES} 
  PATH_SUFFIXES lib lib64 lib32
  DOC "IBM(R) ESSL Library (LP64)"
)

find_library( IBMESSL_ILP64_LIBRARIES
  NAMES ${IBMESSL_ILP64_LIBRARY_NAME}
  HINTS ${IBMESSL_PREFIX}
  PATHS ${IBMESSL_LIBRARY_DIR} ${CMAKE_C_IMPLICIT_LINK_DIRECTORIES} 
  PATH_SUFFIXES lib lib64 lib32
  DOC "IBM(R) ESSL Library (ILP64)"
)




# Components
#if( IBMESSL_INCLUDE_DIR )
#  set( IBMESSL_headers_FOUND TRUE )
#else()
#  set( IBMESSL_headers_FOUND FALSE )
#endif()

if( IBMESSL_ILP64_LIBRARIES )
  set( IBMESSL_ilp64_FOUND TRUE  )
else()
  set( IBMESSL_ilp64_FOUND FALSE )
endif()

if( IBMESSL_LP64_LIBRARIES )
  set( IBMESSL_lp64_FOUND TRUE  )
else()
  set( IBMESSL_lp64_FOUND FALSE )
endif()


# LP64 Default
if( "ilp64" IN_LIST IBMESSL_FIND_COMPONENTS )
  set( IBMESSL_LIBRARIES "${IBMESSL_ILP64_LIBRARIES}" )
  
else()
  set( IBMESSL_LIBRARIES "${IBMESSL_LP64_LIBRARIES}"  )
endif()


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( IBMESSL
  REQUIRED_VARS IBMESSL_LIBRARIES IBMESSL_INCLUDE_DIR
  HANDLE_COMPONENTS
)

#if( IBMESSL_FOUND AND NOT TARGET IBMESSL::essl )
#
#  add_library( IBMESSL::essl INTERFACE IMPORTED )
#  set_target_properties( IBMESSL::essl PROPERTIES
#    INTERFACE_INCLUDE_DIRECTORIES "${IBMESSL_INCLUDE_DIR}"
#    INTERFACE_LINK_LIBRARIES      "${IBMESSL_LIBRARIES}"
#  )
#
#endif()
