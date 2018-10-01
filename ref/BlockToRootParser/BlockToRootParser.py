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
FORT_TO_C_TYPES = {"r":"float", "i":"integer"}
C_TO_FORT_TYPES = {"float":"real", "integer":"integer"}

ERROR_IN_FILE   = "[Error] Input file is not a regular file."
ERROR_IN_ARGS   = "[Error] Not enough input arguments."
INFO_NAMES_FILE = "[Info] Names file not found. It will be created."
INFO_OUT_DIR    = "[Info] Output directory created."
INFO_RESULT     = "[Info] Terminated. You can find the files in output directory."

def main(input_file, output_dir="out"):
    if output_dir == "":
        output_dir="out"
    block_name       = input_file.split(".")[0]
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

    # Open input file and get line
    with open(input_file, "r") as in_file:
        input_lines = in_file.readlines()

    for i,line in enumerate(input_lines):
        splitted_lines = line.split(",")
        # Third field has format 'name:type\n'
        # then we have to clean the string and split it
        # to separate name and type
        third_field = splitted_lines[3].replace(")","").replace("'","").replace("\n","").split(":")

        data.append(splitted_lines[2])

        name_id=-1
        for n,name in enumerate(fortran_names):
            if name==third_field[0]:
                name_id=n
                break
        if name_id==-1:
            content_names += third_field[0] + "\n"
            names.append(third_field[0])
        else:
            names.append(C_names[name_id])

        # Given Fortran type, take the related C type
        types.append(third_field[1])

    # Create Struct.hh content
    content_hh = "extern \"C\" {\n"
    content_hh += "  extern struct {\n"
    for (t,n) in zip(types,names):
        c_type = FORT_TO_C_TYPES.get(t)
        content_hh += "    " + c_type + " " + n + ";\n"
    content_hh += "  }" + block_name + "_;\n"
    content_hh += "}\n"

    # Create sample.cin content
    content_cin = "C\n"
    content_cin += "C  Block: " + block_name + "\n"
    content_cin += "C\n"
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
            if i==0:
                line_names += names[j]
            else:
                line_names += ", " + names[j]
        if not empty_type:
            content_cin += "      " + complete_type + " " + line_names + "\n"
    content_cin += "\n"
    content_cin += "      common /" + block_name + "/"
    for i,n in enumerate(names):
        if i==0:
            content_cin += n
        else:
            content_cin += "," + n
    content_cin += "\n"

    # Create sample.kloe content
    content_kloe = "C-----------------------------------------------------------------------\n"
    content_kloe += "C Fill Block " + block_name + "\n"
    content_kloe += "C-----------------------------------------------------------------------\n"
    for n in names:
        content_kloe += "      " + n + " = 0.\n"
    content_kloe += "\n"
    content_kloe += "      >>>INSERT HERE THE GET FUNCTION<<<\n"
    content_kloe += "\n"
    for (n,d) in zip(names,data):
        content_kloe += "      " + n + " = " + d + "\n"

    # Create TreeWriter.cpp content
    content_cpp = "// Add to the tree all the branches realted to the block " + block_name.upper() + ".\n"
    content_cpp += "//\n// input:\t-\n// output: -\n"
    content_cpp += "void TreeWriter::addBlock" + block_name.upper() + "() {\n"
    for name,t in zip(names,types):
        content_cpp += "    fNewTree->Branch(\"" + name + "\", "
        content_cpp += "&" + block_name + "_." + name + ", "
        content_cpp += "\"" + name + "/" + FORT_TO_ROOT_TYPES.get(t) + "\");\n"
    content_cpp += "}\n"

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
