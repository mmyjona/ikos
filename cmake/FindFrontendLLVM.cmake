#*******************************************************************************
#
# Find IKOS llvm frontend headers and library.
#
# Author: Maxime Arthaud
#
# Contact: ikos@lists.nasa.gov
#
# Notices:
#
# Copyright (c) 2011-2018 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
# Disclaimers:
#
# No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY OF
# ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED
# TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL CONFORM TO SPECIFICATIONS,
# ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
# OR FREEDOM FROM INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE
# ERROR FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM TO
# THE SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER, CONSTITUTE AN
# ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT OF ANY RESULTS,
# RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY OTHER APPLICATIONS
# RESULTING FROM USE OF THE SUBJECT SOFTWARE.  FURTHER, GOVERNMENT AGENCY
# DISCLAIMS ALL WARRANTIES AND LIABILITIES REGARDING THIRD-PARTY SOFTWARE,
# IF PRESENT IN THE ORIGINAL SOFTWARE, AND DISTRIBUTES IT "AS IS."
#
# Waiver and Indemnity:  RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST
# THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL
# AS ANY PRIOR RECIPIENT.  IF RECIPIENT'S USE OF THE SUBJECT SOFTWARE RESULTS
# IN ANY LIABILITIES, DEMANDS, DAMAGES, EXPENSES OR LOSSES ARISING FROM SUCH
# USE, INCLUDING ANY DAMAGES FROM PRODUCTS BASED ON, OR RESULTING FROM,
# RECIPIENT'S USE OF THE SUBJECT SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD
# HARMLESS THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS,
# AS WELL AS ANY PRIOR RECIPIENT, TO THE EXTENT PERMITTED BY LAW.
# RECIPIENT'S SOLE REMEDY FOR ANY SUCH MATTER SHALL BE THE IMMEDIATE,
# UNILATERAL TERMINATION OF THIS AGREEMENT.
#
#*****************************************************************************/

if (NOT FRONTEND_LLVM_FOUND)
  set(FRONTEND_LLVM_INCLUDE_SEARCH_DIRS "")
  set(FRONTEND_LLVM_LIB_SEARCH_DIRS "")
  set(FRONTEND_LLVM_BIN_SEARCH_DIRS "")

  # use FRONTEND_LLVM_ROOT as a hint
  set(FRONTEND_LLVM_ROOT "" CACHE PATH "Path to ikos llvm frontend install directory.")

  if (FRONTEND_LLVM_ROOT)
    list(APPEND FRONTEND_LLVM_INCLUDE_SEARCH_DIRS "${FRONTEND_LLVM_ROOT}/include")
    list(APPEND FRONTEND_LLVM_LIB_SEARCH_DIRS "${FRONTEND_LLVM_ROOT}/lib")
    list(APPEND FRONTEND_LLVM_BIN_SEARCH_DIRS "${FRONTEND_LLVM_ROOT}/bin")
  endif()

  # use ikos-config as a hint
  find_program(IKOS_CONFIG_EXECUTABLE CACHE NAMES ikos-config DOC "ikos-config executable")

  if (IKOS_CONFIG_EXECUTABLE)
    execute_process(
      COMMAND ${IKOS_CONFIG_EXECUTABLE} --includedir
      OUTPUT_VARIABLE IKOS_CONFIG_INCLUDE_DIR
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
      COMMAND ${IKOS_CONFIG_EXECUTABLE} --libdir
      OUTPUT_VARIABLE IKOS_CONFIG_LIB_DIR
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
      COMMAND ${IKOS_CONFIG_EXECUTABLE} --bindir
      OUTPUT_VARIABLE IKOS_CONFIG_BIN_DIR
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    list(APPEND FRONTEND_LLVM_INCLUDE_SEARCH_DIRS "${IKOS_CONFIG_INCLUDE_DIR}")
    list(APPEND FRONTEND_LLVM_LIB_SEARCH_DIRS "${IKOS_CONFIG_LIB_DIR}")
    list(APPEND FRONTEND_LLVM_BIN_SEARCH_DIRS "${IKOS_CONFIG_BIN_DIR}")
  endif()

  find_path(FRONTEND_LLVM_INCLUDE_DIR
    NAMES ikos/frontend/llvm/import.hpp
    HINTS ${FRONTEND_LLVM_INCLUDE_SEARCH_DIRS}
  )

  find_library(FRONTEND_LLVM_TO_AR_LIB
    NAMES ikos-llvm-to-ar
    HINTS ${FRONTEND_LLVM_LIB_SEARCH_DIRS}
  )

  find_program(FRONTEND_LLVM_IKOS_PP_BIN
    NAMES ikos-pp
    HINTS ${FRONTEND_LLVM_BIN_SEARCH_DIRS}
  )

  mark_as_advanced(FRONTEND_LLVM_INCLUDE_DIR FRONTEND_LLVM_TO_AR_LIB FRONTEND_LLVM_IKOS_PP_BIN)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(FrontendLLVM
    REQUIRED_VARS FRONTEND_LLVM_INCLUDE_DIR FRONTEND_LLVM_TO_AR_LIB FRONTEND_LLVM_IKOS_PP_BIN
    FAIL_MESSAGE "Could NOT find ikos llvm frontend. Please provide -DFRONTEND_LLVM_ROOT=<directory>")
endif()