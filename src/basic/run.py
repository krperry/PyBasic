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

"""This script loads and runs a BASIC program from a .bas file."""

import sys
import os
from lexer import Lexer
from program import Program

def main():
    if len(sys.argv) != 2:
        print("Usage: python run.py <filename.bas>")
        sys.exit(1)

    filename = sys.argv[1]

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
    except Exception as e:
        print(f"Error while running the program: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
    