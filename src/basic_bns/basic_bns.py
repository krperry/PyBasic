#!/usr/bin/env python3
"""
basic-bns: A command-line tool for disassembling BASIC binary files

This tool uses the disassembler library to convert compiled BASIC files
into readable source code.
"""

import sys
import os
from disassembler.dc import disassemble_file
from basic.basichost import host

def main():
    """
    Main entry point for the basic-bns command
    """
    if len(sys.argv) < 2:
        host.print("Usage: basic-bns <compiled_file.bas>")
        host.print("       Disassembles a BASIC binary file to readable source code")
        host.print("")
        host.print("Output files:")
        host.print("  <compiled_file>.src - Human-readable BASIC source code")
        host.print("  <compiled_file>.bit - Binary representation for debugging")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    # Check if input file exists
    if not os.path.exists(input_file):
        host.print(f"Error: File '{input_file}' not found")
        sys.exit(1)
    
    # Check if it's a .BAS file (case insensitive)
    if not input_file.lower().endswith('.bas'):
        host.print(f"Warning: File '{input_file}' doesn't have a .BAS extension")
        host.print("Proceeding anyway...")
    
    try:
        disassemble_file(input_file)
        
        # Generate output filenames for confirmation message
        base_name = input_file.lower().replace('.bas', '')
        src_file = base_name + '.src'
        bit_file = base_name + '.bit'
        
        host.print(f"Successfully disassembled '{input_file}'")
        host.print(f"  Source code: {src_file}")
        print(f"  Binary dump: {bit_file}")
        
    except Exception as e:
        host.print(f"Error disassembling '{input_file}': {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()