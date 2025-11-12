"""
Disassembler for old BASIC on Z80

This package provides tools for disassembling compiled BASIC files
into readable source code.
"""

from .dc import disassemble_file

__version__ = "0.1.0"
__all__ = ["disassemble_file"]