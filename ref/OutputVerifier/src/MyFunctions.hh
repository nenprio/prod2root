#ifndef MYFUNCTIONS_HH
#define MYFUNCTIONS_HH

// Print to std out
void println(const char *line);
void print(const char *line);

// Files and directories
bool checkIfExists(const char *path);
bool checkIfFileExists(const char *file);
bool checkIfDirExists(const char *dir);
bool createDirIfNotExists(const char *dir);
bool createDirRecursively(const char *dir);

// String manipulation
char* cut(char *string, char *delimiter, int field);

#endif
