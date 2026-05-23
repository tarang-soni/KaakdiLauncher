# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appKaakdiLauncher_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appKaakdiLauncher_autogen.dir\\ParseCache.txt"
  "appKaakdiLauncher_autogen"
  )
endif()
