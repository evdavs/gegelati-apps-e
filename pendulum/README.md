# Pendulum

This application teaches a learning agent built with the [GEGELATI library](https://github.com/gegelati/gegelati) how to keep a pendulum at an equilibrium position.

## How to Build?
The build process of applications relies on [cmake](https://cmake.org) to configure a project for a wide variety of development environments and operating systems. Install [cmake](https://cmake.org/download/) on your system before building the application.

### Under windows
1. Copy the `gegelatilib-<version>` folder containing the binaries of the [GEGELATI library](https://github.com/gegelati/gegelati) into the `lib` folder.
2. Open a command line interface in the `bin` folder.
3. Enter the following command to create the project for your favorite IDE `cmake ..`.
4. Open the project created in the `bin` folder, or launch the build with the following command: `cmake --build .`.

## Compile for training
The target `pendulumLearn` is used for training the TPG on the provided Learning Environment. The result of this training are stored under the `logs` directory and under the directory corresponding to the date of execution (i.e `logs/2024-02-26_15-03-00`)
- a set of TPG graphs retracing the best TPG at each generation of the training
- out_best.dot the best TPG found during the whole training
- out_best_stats.md statistics on the TPG. Topology, program size, DataHandlers infos.
- instructions.cpp, params.cpp copy of the files used for retracability
- training_data.csv data on the learning execution for graph visualization

## CodeGen example
The folder src/CodeGen contains an example of use case for the code generation feature of GEGELATI. There are 4 targets for this example:
- `pendulumGenerateCodeGen`: Import the TPG_graph.dot and launch the code generation to create the C sources files. If you want to run this target you need to set your working directory as the current build directory of your build system. You can use the following variable $CMakeCurrentBuildDir$.
- `pendulumExecuteCodeGen`: A custom command to execute the previous target after it is compiled. This will generate the C source files. This command embedds the target `pendulumGenerateCodeGen`. It used to simplify the flow for the next target. 
- `pendulumInferenceCodeGen`: Uses the generated files and link them with the learning environment of the directory `src/Learn`. This target depend on the previous target `pendulumExecuteCodeGen`, so building it will automatically trigger a build of the two previous. This target is used to measure the performance of the generated TPG (C source files). 
- `pendulumInferenceDot`: Import the `TPG_graph.dot` and run it within the pendulum learning environment, in the exact same condition as within the `pendulumInferenceCodeGen` target. This target enables comparing the identical behavior of the generated code and the original TPG.

In brief, only two final targets are made `pendulumInferenceCodeGen` and `pendulumInferenceDot` which are used to compare the efficiency and the codegen against the efficiency of the lib GEGELATI. The result of this comparison are described in the paper: 
Ultra-Fast Machine Learning Inference through C Code Generation for Tangled Program Graphs Karol Desnos, Thomas Bourgoin, Mickael Dardaillon, Nicolas Sourbier, Olivier Gesny, Maxime Pelcat