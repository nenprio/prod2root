#include <string>
#include <iostream>
#include <sys/types.h>
#include <sys/stat.h>

// Simple shortcut function to print a single line to stdout
//
// input:   line        what you want to print out
// output:  -
void println(std::string line){
    std::cout << line << std::endl;
}

// Check the existance of the given input.
//
// input:   path        the path to check
// output:  true        if it exists
//          false       if it doesn't exist
bool checkIfExists(std::string path) {
  struct stat buffer;
  return (stat (path.c_str(), &buffer) == 0);
}

// Check if the given input is a regular file and if it exists.
//
// input:   filepath    the file to check
// output:  true        if the file exists
//          false       if the file doesn't exist
bool checkIfFileExists(std::string file) {
  struct stat buffer;
  return ((stat (file.c_str(), &buffer) == 0) && ( buffer.st_mode & S_IFREG ));
}

// Check if the given input is a directory and if it exists.
//
// input:   dirpath     the directory to check
// output:  true        if the dir exists
//          false       if the dir doesn't exist
bool checkIfDirExists(std::string dir) {
  struct stat buffer;
  return ((stat (dir.c_str(), &buffer) == 0) && ( buffer.st_mode & S_IFDIR ));
}

// Check if the given dir exists and is a dir, otherwise try to create it
// 
// input:   dirPath     path to the dir to create
// output:  bool        it returns true if already exists or dir created successfully
//                      it returns false if some error happens
bool createDirIfNotExists(std::string dirPath) {
     int checkCreated;
     int existsDir=0;
     if (checkIfDirExists(dirPath.c_str())==true) {
         existsDir=1;
     }

     if (existsDir==0){
         checkCreated=mkdir(dirPath.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
         if(checkCreated==-1) {
             return false;
         }
     }
    return true;
}

// Recursive invokation of createDirIfNotExists.
//
// input:   dirPath     path to create, every dir in that path will be created if doesn't exist
// output:  bool        if everything is ok return true, 
//                      if the method find a dir which return false 
//                      than it block itself and return false
bool createDirRecursively(std::string s) {
    std::string delimiter   = "/";
    std::string partialPath = "";

    size_t pos = 0;
    std::string token;
    bool status=true;
    while ((pos = s.find(delimiter)) != std::string::npos) {
        token = s.substr(0, pos);
        status=createDirIfNotExists(partialPath + token);
        if(status==false){
            return false;
        }
        partialPath = partialPath + token + "/";
        s.erase(0, pos + delimiter.length());
    }
    status = createDirIfNotExists(partialPath + s);
    if(status==false){
        return false;
    }
    return true;
}
