            #! /usr/bin/python

# SPDX-License-Identifier: GPL-3.0-or-later
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""This script loads and runs compiled BASIC binary files (.bas.bin) only. No interactive mode to protect source code."""

import argparse
import os
import sys

# Import the disassembler
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from disassembler.dc import read_lines, parse_line
import disassembler.cmds as cmds
import disassembler.dc as dc

# Import BASIC interpreter components
from basic.lexer import Lexer
from basic.program import Program


def disassemble_binary_to_memory(input_filename):
    """
    Disassemble a BASIC binary file and return the source lines as a dictionary.
    
    Args:
        input_filename (str): Path to the input .bas.bin file
        
    Returns:
        dict: Dictionary of line_number -> source_line
    """
    # Reset global state
    dc.while_lookup = []
    
    with open(input_filename, "rb") as basic_file:
        file_buffer = basic_file.read()
    
    buffer_length = len(file_buffer)
    cmds.init_offset_table(file_buffer, buffer_length)
    basic_lines = read_lines(file_buffer, buffer_length)
    
    source_lines = {}
    for line in basic_lines:
        l_number, line_content = parse_line(line[0], line[2])
        source_lines[l_number] = line_content
        
    # Handle while loops
    for lookup in dc.while_lookup:
        if lookup[0] in source_lines:
            source_lines[lookup[0]] += f" else goto {lookup[1]}"

    return source_lines


def load_binary_program(program, filename):
    """
    Load a compiled BASIC binary file into a Program object.
    
    Args:
        program: Program object to load into
        filename: Path to the .bas.bin file
    """
    # Clear the program first
    program.delete()
    
    # Disassemble the binary file to memory
    source_lines = disassemble_binary_to_memory(filename)
    
    # Add each line to the program
    lexer = Lexer()
    for line_num in sorted(source_lines.keys(), key=int):
        line_content = f"{line_num} {source_lines[line_num]}"
        tokenlist = lexer.tokenize(line_content)
        program.add_stmt(tokenlist)


def run_interpreter(program=None):
    """Interactive mode is not available in basic-bns to protect source code."""
    print("Error: Interactive mode is not available in basic-bns.")
    print("This is to protect the source code of compiled binary files.")
    print("Use the regular 'basic' command for interactive mode with .bas files.")
    sys.exit(1)


def run_binary_program(filename):
    """Load and run a compiled BASIC binary program from file."""
    # Ensure the file ends with .bas.bin
    if not filename.lower().endswith(".bas.bin"):
        filename += ".bas.bin"

    # Check if the file exists
    if not os.path.exists(filename):
        print(f"Error: File '{filename}' does not exist.")
        sys.exit(1)

    # Initialize the program
    program = Program()

    try:
        # Load the binary program
        load_binary_program(program, filename)
        # Execute the program
        program.execute()
        return program
    except Exception as e:
        print(f"Error while running the binary program: {e}")
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Load and run compiled BASIC binary programs (.bas.bin) - No interactive mode")
    parser.add_argument("filename", 
                       help="The compiled BASIC binary file to run (.bas.bin extension will be added if not present)")
    
    args = parser.parse_args()

    # Only run binary files - no interactive mode
    run_binary_program(args.filename)


if __name__ == "__main__":
    main()
