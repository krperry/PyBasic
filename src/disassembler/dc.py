import  sys
import disassembler.cmds as cmds

# Global list to hold while loop line numbers
while_lookup = []



def parse_line(line_number,line):
    parsed_line = ""
    
    line = line[4:]
    cmds.line_number = line_number
    if cmds.wend:
        while_lookup.append([cmds.wend,line_number])
        #print(f"while_lookup {while_lookup}")
        cmds.wend = 0
    while line:
        #try:
        part, line =cmds.parse_functions[cmds.cmds[line[0]]](line)
        """except:
            print (f"Error: cmds does not have {line[0]}")
            part = ""
            line = line[1:]
        """

        parsed_line += part
        if line and (line[0] in [4,5,14] or parsed_line.strip().endswith("then") or parsed_line.strip().endswith("else")):
            parsed_line += " "
        elif line:
            parsed_line += " : "

    if parsed_line.strip().endswith("wend"):
        parsed_line= parsed_line.strip()[:-4]
        parsed_line= parsed_line + "goto "+str(line_number)

            
    parsed_line =  parsed_line if parsed_line.strip() else str(line_number) + "  rem  todo add comment"
    # temporary fix for reserved word issue in battle.bas
    parsed_line = parsed_line.replace("max ","maximum ") 
    if parsed_line.endswith("max"):
        parsed_line=parsed_line[:-3]+"maximum"
    return [str(line_number),parsed_line]
    

def read_lines(file:bytes, length:int):
    """read entire lines into a list of lines 
    The lines will be in the following form once read
    line number, length of line in data file, byte string
    """
    bas_lines = []
    index = 0
    while index <length:
        line_data_index =index
        index+=1
        if index >= length:
            continue
        line_number = file[index]
        index+=1
        if index >= length:
            continue
        line_number += file[index]*256
        index += 1
        if index >= length:
            continue
        size = file[index]
        line = file[line_data_index:(line_data_index+size+1)]
        bas_lines.append([line_number,size,line])
        index=line_data_index+size+1
    return bas_lines


def disassemble_file(input_filename, output_src_filename=None, output_bits_filename=None):
    """
    Disassemble a BASIC binary file and generate source and bits files.
    
    Args:
        input_filename (str): Path to the input .BAS file
        output_src_filename (str, optional): Path for the .src output file. 
                                           Defaults to input_filename with .src extension.
        output_bits_filename (str, optional): Path for the .bit output file.
                                            Defaults to input_filename with .bit extension.
    """
    global while_lookup
    while_lookup = []  # Reset global state
    
    with open(input_filename, "rb") as basic_file:
        file_buffer = basic_file.read()
    
    buffer_length = len(file_buffer)
    cmds.init_offset_table(file_buffer, buffer_length)
    basic_lines = read_lines(file_buffer, buffer_length)
    
    # Generate output filenames if not provided
    if output_src_filename is None:
        output_src_filename = input_filename.lower().replace(".bas", ".src")
    if output_bits_filename is None:
        output_bits_filename = input_filename.lower().replace(".bas", ".bit")

    with open(output_src_filename, "w") as file_src, open(output_bits_filename, "w") as file_bits:
        source_lines = {}
        for line in basic_lines:
            file_bits.write(f"{line}\n")
            l_number, line = parse_line(line[0], line[2])
            source_lines[l_number] = line
            
        for lookup in while_lookup:
            source_lines[lookup[0]] += f" else goto {lookup[1]}"

        for key in source_lines.keys():
            file_src.write(f"{key} {source_lines[key]}\n")


def main():
    """
    Command-line interface for the disassembler
    """
    if len(sys.argv) < 2:
        print("Usage:")
        print("python dc.py <compiled file>")
        sys.exit(1)
        
    filename = sys.argv[1]
    disassemble_file(filename)






if __name__ == "__main__":
    main()
