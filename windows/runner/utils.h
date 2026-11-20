#ifndef RUNNER_UTILS_H_
#define RUNNER_UTILS_H_

#include <string>
#include <vector>

// Creates a console for the process, and attaches stdout/stderr to it.
void CreateAndAttachConsole();

// Gets the command line arguments passed to the process.
std::vector<std::string> GetCommandLineArguments();

#endif  // RUNNER_UTILS_H_