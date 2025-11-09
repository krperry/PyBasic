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

"""This script loads and runs a BASIC program from a .bas file or provides an interactive interpreter."""

import argparse
import os
import sys
from basic.basictoken import BASICToken as Token
from basic.lexer import Lexer
from basic.program import Program
from sys import stderr


def run_interpreter(program=None):
    """Run the interactive BASIC interpreter."""
    lexer = Lexer()
    if program is None:
        program = Program()

    print("PyBASIC Interpreter")
    print("Type EXIT to quit")
    print()

    # Continuously accept user input and act on it until
    # the user enters 'EXIT'
    while True:

        stmt = input('> ')

        try:
            tokenlist = lexer.tokenize(stmt)

            # Execute commands directly, otherwise
            # add program statements to the stored
            # BASIC program

            if len(tokenlist) > 0:

                # Exit the interpreter
                if tokenlist[0].category == Token.EXIT:
                    break

                # Add a new program statement, beginning
                # a line number
                elif tokenlist[0].category == Token.UNSIGNEDINT\
                     and len(tokenlist) > 1:
                    program.add_stmt(tokenlist)

                # Delete a statement from the program
                elif tokenlist[0].category == Token.UNSIGNEDINT \
                        and len(tokenlist) == 1:
                    program.delete_statement(int(tokenlist[0].lexeme))

                # Execute the program
                elif tokenlist[0].category == Token.RUN:
                    try:
                        program.execute()

                    except KeyboardInterrupt:
                        print("Program terminated")

                # List the program
                elif tokenlist[0].category == Token.LIST:
                     if len(tokenlist) == 2:
                         program.list(int(tokenlist[1].lexeme),int(tokenlist[1].lexeme))
                     elif len(tokenlist) == 3:
                         # if we have 3 tokens, it might be LIST x y for a range
                         # or LIST -y or list x- for a start to y, or x to end
                         if tokenlist[1].lexeme == "-":
                             program.list(None, int(tokenlist[2].lexeme))
                         elif tokenlist[2].lexeme == "-":
                             program.list(int(tokenlist[1].lexeme), None)
                         else:
                             program.list(int(tokenlist[1].lexeme),int(tokenlist[2].lexeme))
                     elif len(tokenlist) == 4:
                         # if we have 4, assume LIST x-y or some other
                         # delimiter for a range
                         program.list(int(tokenlist[1].lexeme),int(tokenlist[3].lexeme))
                     else:
                         program.list()

                # Save the program to disk
                elif tokenlist[0].category == Token.SAVE:
                    program.save(tokenlist[1].lexeme)
                    print("Program written to file")

                # Load the program from disk
                elif tokenlist[0].category == Token.LOAD:
                    program.load(tokenlist[1].lexeme)
                    print("Program read from file")

                # Delete the program from memory
                elif tokenlist[0].category == Token.NEW:
                    program.delete()

                # Unrecognised input
                else:
                    print("Unrecognised input", file=stderr)
                    for token in tokenlist:
                        token.print_lexeme()
                    print(flush=True)

        # Trap all exceptions so that interpreter
        # keeps running
        except Exception as e:
            print(e, file=stderr, flush=True)


def run_program(filename):
    """Load and run a BASIC program from file."""
    # Ensure the file ends with .bas
    if not filename.lower().endswith(".bas"):
        filename += ".bas"

    # Check if the file exists
    if not os.path.exists(filename):
        print(f"Error: File '{filename}' does not exist.")
        sys.exit(1)

    # Initialize the lexer and program
    lexer = Lexer()
    program = Program()

    try:
        # Load the program
        program.load(filename)
        # Execute the program
        program.execute()
        return program
    except Exception as e:
        print(f"Error while running the program: {e}")
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Load and run a BASIC program or start interactive interpreter")
    parser.add_argument("-i", "--interactive", action="store_true", 
                       help="Start interactive interpreter (optionally after running a file)")
    parser.add_argument("filename", nargs="?", 
                       help="The BASIC program file to run (.bas extension will be added if not present)")
    
    args = parser.parse_args()

    if args.interactive:
        if args.filename:
            # Run the file first, then enter interactive mode with the loaded program
            print(f"Loading and running {args.filename}...")
            program = run_program(args.filename)
            print("\nEntering interactive mode...")
            run_interpreter(program)
        else:
            # Just start interactive mode
            run_interpreter()
    else:
        if args.filename:
            # Just run the file
            run_program(args.filename)
        else:
            # No filename and no interactive flag - show help
            parser.print_help()
            sys.exit(1)


if __name__ == "__main__":
    main()
