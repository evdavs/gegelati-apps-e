cmake_minimum_required(VERSION 3.12.4)

# *******************************************
# ************* CMake Content ***************
# *******************************************
# This CMake create a workspace containing the following projects
# 
# Programs
#  - pendulum

set(PROJECT_NAME pendulum)

project(${PROJECT_NAME})

option(TESTING "Is the program compiled for tests only (without display)." ON)

# Add definition for relative path into project
add_definitions(-DPROJECT_ROOT_PATH="${CMAKE_CURRENT_SOURCE_DIR}")

# Disable C and C++ compiler extensions.
# C/CXX_EXTENSIONS are ON by default to allow the compilers to use extended
# variants of the C/CXX language.
# However, this could expose cross-platform bugs in user code or in the headers
# of third-party dependencies and thus it is strongly suggested to turn
# extensions off.
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(NOT ${CMAKE_GENERATOR} MATCHES "Visual Studio.*")

	# Link with pthread
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")

	# Debug or release
	if(CMAKE_BUILD_TYPE MATCHES "Debug")
			MESSAGE("Generate Debug project")
			set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/Debug)
			# Compiling with -pg instruments your code, so that Gprof reports detailed information.
			set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -pg -Wall")
	else()
			MESSAGE("Generate Release project")
			set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/Release)
			set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall")
	endif()
	#add libmath during non visual studio builds
	set(CMAKE_EXTRA_LIB m)
else()
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

# Add definitions for testing purposes
if(${TESTING})
	MESSAGE("Testing mode")
	add_definitions(-DNO_CONSOLE_CONTROL) #-DNB_GENERATIONS=2
endif()

# *******************************************
# *********** GEGELATI LIBRARY **************
# *******************************************

if(WIN32)
	set(LIBS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/lib)
    # find the gegelatilib-x.y.z folder in the lib directory.
	file(GLOB GEGELATI_ROOT_DIR "${LIBS_DIR}/gegelatilib-[\\.|0-9]*")
	set(ENV{GEGELATI_DIR} ${GEGELATI_ROOT_DIR})
endif()
find_package(GEGELATI)


if (WIN32)
	file(GLOB
		GEGELATI_DLL
		${GEGELATI_ROOT_DIR}/bin/*.dll
	)

	MESSAGE("Copy GEGELATI DLLs into ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
	file(COPY ${GEGELATI_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
	if(${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
		file(COPY ${GEGELATI_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Debug)
		file(COPY ${GEGELATI_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Release)
	endif()
endif()

if(NOT ${TESTING})
	# *******************************************
	# ************** SDL2 LIBRARY ***************
	# *******************************************	
	set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/lib/cmake_modules/")

	if(WIN32)
		# Set variables before finding SDL Library
		# Helps to find where SDL libraries are saved (win32 only)
		set(LIBS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/lib)
		# find the SDL2-x.y.z folder in the lib directory.
		file(GLOB SDL2DIR "${LIBS_DIR}/SDL2-[\\.|0-9]*")
		set(ENV{SDL2DIR} ${SDL2DIR})
	endif()
	
	Find_Package (SDL2 REQUIRED)
	
	if(NOT SDL2_FOUND)
	MESSAGE(FATAL_ERROR "SDL not found !")
	endif()
	
	if (WIN32)
		file(GLOB
			SDL2_DLL
			${SDL2DIR}/bin/*.dll
			${SDL2DIR}/lib/*.dll
		)
	
		MESSAGE("Copy SDL DLLs into ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
		if(NOT ${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
			file(COPY ${SDL2_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
		else()
			file(COPY ${SDL2_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Debug)
			file(COPY ${SDL2_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Release)
		endif()
	endif()
	
	# *******************************************
	# *********** SDL2_image LIBRARY ************
	# *******************************************
	# Set variables before finding SDL_image Library
	# Helps to find where SDL libraries are saved (win32 only)
	
	if(WIN32)
		# find the SDL2_image-x.y.z folder in the lib directory.
		file(GLOB SDL2IMAGEDIR "${LIBS_DIR}/SDL2_image-[\\.|0-9]*")
		set(ENV{SDL2IMAGEDIR} ${SDL2IMAGEDIR})
	endif()
	
	Find_Package (SDL2_image REQUIRED)
	
	if(NOT SDL2IMAGE_FOUND)
	MESSAGE(FATAL_ERROR "SDL Image not found !")
	endif()
	
	if (WIN32)
		file(GLOB
			SDL2_IMAGE_DLL
			${SDL2IMAGEDIR}/bin/*.dll
			${SDL2IMAGEDIR}/lib/*.dll
		)
	
		MESSAGE("Copy SDL Image DLLs into ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
		if(NOT ${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
			file(COPY ${SDL2_IMAGE_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
		else()
			file(COPY ${SDL2_IMAGE_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Debug)
			file(COPY ${SDL2_IMAGE_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Release)
		endif()
	endif()
	
	# *******************************************
	# ************ SDL2TTF LIBRARY **************
	# ******************************************
	# Set variables before finding SDL2TTF Library
	# Helps to find where SDL2TTF libraries are saved (win32 only)
	if(WIN32)
		# find the SDL2_ttf-x.y.z folder in the lib directory.
		file(GLOB SDL2TTFDIR "${LIBS_DIR}/SDL2_ttf-[\\.|0-9]*")
		set(ENV{SDL2TTFDIR} ${SDL2TTFDIR})
	endif()
		
	Find_Package (SDL2TTF REQUIRED)
	
	if(NOT SDL2TTF_FOUND)
	MESSAGE(FATAL_ERROR "SDL2TTF not found !")
	endif()
	
	if (WIN32)
		file(GLOB
			SDL2TTF_DLL
			${SDL2TTFDIR}/bin/*.dll
			${SDL2TTFDIR}/lib/*.dll
		)
	
		MESSAGE("Copy SDL2_ttf DLLs into ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
		if(NOT ${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
			file(COPY ${SDL2TTF_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
		else()
			file(COPY ${SDL2TTF_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Debug)
			file(COPY ${SDL2TTF_DLL} DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/Release)
		endif()
	endif()
endif()
	
# *******************************************
# ************** Executable  ****************
# *******************************************

# Executable to learn the TPG
file(GLOB_RECURSE
	PENDULUM_FILES
	./src/Learn/*.cpp
	./src/Learn/*.h
	./params.json
)

if(${TESTING})
	list(REMOVE_ITEM PENDULUM_FILES "${CMAKE_CURRENT_SOURCE_DIR}/./src/Learn/render.cpp")
endif()

## Read the README.md associated to the project to understand the structure of the targets.

## ${PROJECT_NAME} target for Training the TPG on the Pendulum ##
include_directories(${GEGELATI_INCLUDE_DIRS}  ${SDL2_INCLUDE_DIR} ${SDL2IMAGE_INCLUDE_DIR} ${SDL2TTF_INCLUDE_DIR})
set(TARGET_LEARN ${PROJECT_NAME}Learn)
add_executable(${TARGET_LEARN} ${PENDULUM_FILES})
target_link_libraries(${TARGET_LEARN} ${GEGELATI_LIBRARIES} ${SDL2_LIBRARY} ${SDL2IMAGE_LIBRARY} ${SDL2TTF_LIBRARY})
target_compile_definitions(${TARGET_LEARN} PRIVATE ROOT_DIR="${CMAKE_SOURCE_DIR}")


## ${PROJECT_NAME}GenerateCodeGen target for generating the epurated code of the TPG trained (faster than with lib) ##
# Code Generation (codegen) example with the TPG stored in the file pendulum/src/CodeGen/out_best.dot
# Create the target that will generate the C code of the TPG, this is the codegen target
set(TARGET_CODEGEN ${PROJECT_NAME}GenerateCodeGen)
add_executable(${TARGET_CODEGEN} src/Learn/instructions.cpp src/CodeGen/mainGenerateCodeGen.cpp)
target_link_libraries(${TARGET_CODEGEN} ${GEGELATI_LIBRARIES})
target_compile_definitions(${TARGET_CODEGEN} PRIVATE ROOT_DIR="${CMAKE_SOURCE_DIR}")
if (WIN32)
  set_target_properties(${TARGET_CODEGEN} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_BINARY_DIR})
  set_target_properties(${TARGET_CODEGEN} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_BINARY_DIR})
endif()

## regroup codegen files ##
# set and create the source directory (SRC_CODEGEN_GENERATED) where file generated by the codegen are saved. 
set(SRC_CODEGEN_GENERATED ${CMAKE_CURRENT_BINARY_DIR}/src/)
file(MAKE_DIRECTORY ${SRC_CODEGEN_GENERATED})
# set the source directory of the main file used for codegen
set(SRC_CODEGEN_MAIN ./src/CodeGen)
include_directories(${SRC_CODEGEN_GENERATED} ${SRC_CODEGEN_MAIN})
# set a variable CODEGEN_FILES that groups all the codegen files
set(CODEGEN_FILES ${SRC_CODEGEN_GENERATED}/TPGtree.c ${SRC_CODEGEN_GENERATED}/TPGprograms.c ${SRC_CODEGEN_GENERATED}/TPGtree.h ${SRC_CODEGEN_GENERATED}/TPGprograms.h)
# set codeGen source file as generated
set_source_files_properties(${CODEGEN_FILES} PROPERTIES GENERATED TRUE)


## wrap generation of source files in a custom command + custom target for directly executing the CodeGen ##
# make ${EXEC_CODEGEN} is the union of "make ${TARGET_CODEGEN}" + "./${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_CODEGEN})"
add_custom_command(OUTPUT ${CODEGEN_FILES} COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TARGET_CODEGEN})
set(EXEC_CODEGEN ${PROJECT_NAME}ExecuteCodeGen)
add_custom_target(${EXEC_CODEGEN} DEPENDS ${CODEGEN_FILES})
add_dependencies(${EXEC_CODEGEN} ${TARGET_CODEGEN})


## ${PROJECT_NAME}InferenceCodegen target for measuring the perf of the TPG during Inference ##
# name for the executable that use the previously generated codegen files to do an inference
set(TARGET_INFERENCE_CODEGEN ${PROJECT_NAME}InferenceCodeGen)
# create binary that need the generated file
set(INFERENCE_CODEGEN_FILES ${SRC_CODEGEN_MAIN}/mainInferenceCodeGen.cpp ./src/Learn/instructions.cpp ./src/Learn/render.cpp ${CODEGEN_FILES})
if(${TESTING})
	list(REMOVE_ITEM INFERENCE_CODEGEN_FILES "./src/Learn/render.cpp")
endif()
add_executable(${TARGET_INFERENCE_CODEGEN} ${INFERENCE_CODEGEN_FILES})
target_link_libraries(${TARGET_INFERENCE_CODEGEN} ${GEGELATI_LIBRARIES} ${SDL2_LIBRARY} ${SDL2IMAGE_LIBRARY} ${SDL2TTF_LIBRARY})
target_include_directories(${TARGET_INFERENCE_CODEGEN} BEFORE PUBLIC ${SRC_CODEGEN_GENERATED}) 
target_compile_definitions(${TARGET_INFERENCE_CODEGEN} PRIVATE ROOT_DIR="${CMAKE_SOURCE_DIR}")
# set the custom target that generate the source file as a dependency of the target
add_dependencies(${TARGET_INFERENCE_CODEGEN} ${EXEC_CODEGEN})


## ${PROJECT_NAME}InferenceDot target for measuring the perf of the TPG during Inference ##
# Create a project that does the inference from the dot 
set(TARGET_INFERENCE_DOT ${PROJECT_NAME}InferenceDot)
set(INFERENCE_DOT_FILES ${PENDULUM_FILES} ${SRC_CODEGEN_MAIN}/mainInferenceDot.cpp)
list(REMOVE_ITEM INFERENCE_DOT_FILES "${CMAKE_CURRENT_SOURCE_DIR}/./src/Learn/main.cpp")
add_executable(${TARGET_INFERENCE_DOT} ${INFERENCE_DOT_FILES})
target_compile_definitions(${TARGET_INFERENCE_DOT} PRIVATE ROOT_DIR="${CMAKE_SOURCE_DIR}")
target_link_libraries(${TARGET_INFERENCE_DOT} ${GEGELATI_LIBRARIES}  ${SDL2_LIBRARY} ${SDL2IMAGE_LIBRARY} ${SDL2TTF_LIBRARY})