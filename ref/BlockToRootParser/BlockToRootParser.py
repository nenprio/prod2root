# Input:
#   HBCall(field, data1, name1)
#   HBCall(field, data2, name2)
#   HBCall(field, data3, name3)
# Output:
#   >>>>toSample.cin
#       type1 name1,name2
#       type2 name3
#
#       common/BLOCKNAME/name1, name2, name3
#   >>>>toSample.kloe
#       name1 = 0.
#       name2 = 0.
#       name3 = 0.
#
#       C Put you Get function here
#
#       name1 = data1
#       name2 = data2
#       name3 = data3
#   >>>>toStruct.hh
#       extern C {
#           struct BLOCKNAME{
#               type1 name1;
#               type2 name2;
#               type3 name3;
#           }
#       }

import os
import sys

FORT_TO_ROOT_TYPES = {"r":"F", "i":"I"}
FORT_TO_C_TYPES = {"r":"float", "i":"int"}
C_TO_FORT_TYPES = {"float":"real", "int":"integer"}

ERROR_IN_FILE   = "[Error] Input file is not a regular file."
ERROR_IN_ARGS   = "[Error] Not enough input arguments."
INFO_NAMES_FILE = "[Info] Names file not found. It will be created."
INFO_OUT_DIR    = "[Info] Output directory created."
INFO_RESULT     = "[Info] Terminated. You can find the files in output directory."

# Create Struct.hh content
#
# input:     -
# output:    content of Struct.hh as string
def getStructContent(block_name, names, types, nameIsArray):
    content = "extern \"C\" {\n"
    content += "  extern struct {\n"
    for i,(t,n) in enumerate(zip(types,names)):
        c_type = FORT_TO_C_TYPES.get(t)
        if nameIsArray[i]:
            content += "    " + c_type + " " + n + "[>MAX-VALUE<];\n"
        else:
            content += "    " + c_type + " " + n + ";\n"
    content += "  }" + block_name + "_;\n"
    content += "}\n"
    return content

# Create sample.cin content
#
# input:  -
# output: content of cin file as string.
def getCinContent(block_name, names, types, nameIsArray):
    content = "C\n"
    content += "C  Block: " + block_name + "\n"
    content += "C\n"
    if True in nameIsArray:
        content += "      integer i" + block_name.upper() + "\n"
    for f_type in FORT_TO_C_TYPES.keys():
        empty_type = True
        complete_type = C_TO_FORT_TYPES.get(FORT_TO_C_TYPES.get(f_type))
        group = []
        for i,t in enumerate(types):
            if f_type==t:
                group.append(i)
                empty_type = False
        line_names = ""
        for i,j in enumerate(group):
            if nameIsArray[j]:
                current_name = names[j] + "(>>>MAX-SIZE<<<)"
            else:
                current_name = names[j]
            if i==0:
                line_names += current_name
            else:
                line_names += ", " + current_name
        if not empty_type:
            content += "      " + complete_type + " " + line_names + "\n"
    content += "\n"
    content += "      common /" + block_name + "/"
    for i,name in enumerate(names):
        if i==0:
            content += name
        else:
            content += "," + name
    content += "\n"
    return content

# Create sample.kloe content
#
# input:  -
# output: content of kloe file as string.
def getKloeContent(block_name, names, data, nameIsArray):
    content = "C-----------------------------------------------------------------------\n"
    content += "C Fill Block " + block_name + "\n"
    content += "C-----------------------------------------------------------------------\n"
    arrays = list()
    for i,n in enumerate(names):
        if nameIsArray[i]:
            arrays.append(i)
        else:
            content += "      " + n + " = 0.\n"

    # Initialize all arrays to zero
    if len(arrays)>0:
        content += "      DO i" + block_name.upper() + "=1, >>>MAX-SIZE<<<\n"
    for j in arrays:
        content += "        " +  names[j] + "(i" + block_name.upper() + ") = 0.\n"
    if len(arrays)>0:
        content += "      END DO\n"

    content += "\n"
    content += "      >>>INSERT HERE THE GET FUNCTION<<<\n"
    content += "\n"
    for i,(n,d) in enumerate(zip(names,data)):
        if not nameIsArray[i]:
            content += "      " + n + " = " + d + "\n"

    # Initialize all arrays to zero
    if len(arrays)>0:
        content += "      IF (>INDEX-VAR< > 0 .OR. >INDEX-VAR< <= >MAX-VALUE<) THEN\n"
        content += "        DO i" + block_name.upper() + "=1, >INDEX-VAR<\n"
    for j in arrays:
        content += "          " + names[j] + "(i" + block_name.upper() + ") = " + data[j] + "(i" + block_name.upper() + ")\n"
    if len(arrays)>0:
        content += "        END DO\n"
        content += "      ELSE THEN\n"
        content += "        WRITE(*,*) \'ERROR " + block_name.upper() + " - >INDEX-VAR< Out of bound : \', >INDEX-VAR<\n"
        content += "      END IF\n"
    return content

# Create TreeWriter.cpp content
#
# input:  -
# output: content of cpp file as string.
def getCppContent(block_name, names, types, nameIsArray):
    content = "// Add to the tree all the branches realted to the block " + block_name.upper() + ".\n"
    content += "//\n// input:\t-\n// output: -\n"
    content += "void TreeWriter::addBlock" + block_name.upper() + "() {\n"
    for i,(name,t) in enumerate(zip(names,types)):
        if nameIsArray[i]:
            content += "    fNewTree->Branch(\"" + name + "\", "
            content += "&" + block_name + "_." + name + ", "
            content += "\"" + name + "[>INDEX-VAR<]/" + FORT_TO_ROOT_TYPES.get(t) + "\");\n"
        else:
            content += "    fNewTree->Branch(\"" + name + "\", "
            content += "&" + block_name + "_." + name + ", "
            content += "\"" + name + "/" + FORT_TO_ROOT_TYPES.get(t) + "\");\n"
    content += "}\n"
    return content

# Main method called on running BlockToRootParser.py
#
# input:  input_file    file containing the block infos, format explained above (see the file begining)
#         output_dir    directory where write the output files, if it doesn't exist then it will be created.
#                       if no output_dir then "./out/" will be used by default.
# output: -
def main(input_file, output_dir="out"):
    if output_dir == "":
        output_dir="out"
    block_name       = input_file.split("/")[-1].split(".")[0]
    names_file       = output_dir + "/" + block_name + "_names.in"
    output_file_cin  = output_dir + "/" + block_name + "_toSample.cin"
    output_file_kloe = output_dir + "/" + block_name + "_toSample.kloe"
    output_file_hh   = output_dir + "/" + block_name + "_toStruct.hh"
    output_file_cpp  = output_dir + "/" + block_name + "_toTreeWriter.cpp"

    # Check if input file exists
    if not os.path.isfile(input_file):
        print ERROR_IN_FILE + " (" + input_file + ")"
        exit(1)

    # Check if output directory exists, otherwise create it
    if not os.path.exists(output_dir):
        print INFO_OUT_DIR + " (" + output_dir + ")"
        os.makedirs(output_dir)

    # Check if names file exists, eventually get the content
    fortran_names = list()
    C_names       = list()
    if os.path.isfile(names_file):
        with open(names_file, "r") as names:
            names_lines = names.readlines()
            for line in names_lines:
                split = line.replace("\n","").split(" ")
                fortran_names.append(split[0])
                if len(split)<2:
                    C_names.append(split[0])
                else:
                    C_names.append(split[1])
            content_names = ''.join(names_lines)
    else:
        content_names = ""
        print INFO_NAMES_FILE + " (" + names_file + ")"

    # Data, names, types lists initialization
    data  = list()
    names = list()
    types = list()
    nameIsArray = list()

    # Open input file and get line
    with open(input_file, "r") as in_file:
        input_lines = in_file.readlines()

    for i,line in enumerate(input_lines):
        splitted_lines = line.split(",")
        # Third field has format 'name:type\n'
        # then we have to clean the string and split it
        # to separate name and type
        third_field = splitted_lines[3].replace(")","").replace("'","").replace("\n","").split(":")
        current_name = third_field[0]

        data.append(splitted_lines[2])

        if "(" in current_name:
            current_name = current_name.split("(")[0]
            nameIsArray.append(True)
        else:
            nameIsArray.append(False)

        name_id=-1
        for n,name in enumerate(fortran_names):
            if name==current_name:
                name_id=n
                break
        if name_id==-1:
            content_names += current_name + "\n"
            names.append(current_name)
        else:
            names.append(C_names[name_id])

        # Given Fortran type, take the related C type
        types.append(third_field[1])

    # Create files content
    content_hh   = getStructContent(block_name, names, types, nameIsArray)
    content_cin  = getCinContent(block_name, names, types, nameIsArray)
    content_kloe = getKloeContent(block_name, names, data, nameIsArray)
    content_cpp  = getCppContent(block_name, names, types, nameIsArray)

    # Create output files
    with open(output_file_cin, "w") as cin:
        cin.write(content_cin)

    with open(output_file_kloe, "w") as kloe:
        kloe.write(content_kloe)

    with open(output_file_hh, "w") as hh:
        hh.write(content_hh)

    with open(output_file_cpp, "w") as cpp:
        cpp.write(content_cpp)

    with open(names_file, "w") as nm:
        nm.write(content_names)

    print INFO_RESULT + " (" + output_dir + ")"
    exit(0)

if __name__ == "__main__":
    # Check for sufficient number of arguments
    if len(sys.argv) < 2:
        print ERROR_IN_ARGS + "\n"
        print "Usage: %s input_file [output_directory]" %sys.argv[0]
        exit(1)

    # Take the input file
    in_file = sys.argv[1]

    # Check if exists second parameter
    if len(sys.argv) > 2:
        out_dir = sys.argv[2]   # Take the output directory
    else:
        out_dir = ""

    # Run the main
    main(in_file, out_dir)
