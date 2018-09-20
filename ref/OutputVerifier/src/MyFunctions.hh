#ifndef MYFUNCTIONS_HH
#define MYFUNCTIONS_HH

void println(const char *line);
void print(const char *line);
bool checkIfExists(const char *path);
bool checkIfFileExists(const char *file);
bool checkIfDirExists(const char *dir);
bool createDirIfNotExists(const char *dir);
bool createDirRecursively(const char *dir);

#endif
