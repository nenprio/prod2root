#ifndef MYFUNCTIONS_HH
#define MYFUNCTIONS_HH
#include <string>

void println(std::string line);
bool checkIfExists(std::string path);
bool checkIfFileExists(std::string file);
bool checkIfDirExists(std::string dir);
bool createDirIfNotExists(std::string dir);
bool createDirRecursively(std::string dir);
#endif
