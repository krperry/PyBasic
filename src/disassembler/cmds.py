import re
# for storing lookups for converting file position to line number
offset_table = {}

# store all lines that have a goto or gosub pointing at them.
jump_lines = []


cmds = [
    "error",
    "print",
    "input",
    "if",
    "then",
    "else",
    "goto",
    "gosub",
    "return",
    "dim",
    "get", #10
    "for",
    "to",
    "step",
    "next",
    "while",
    "wend",
    "open",
    "close",
    "clear",
    "create", #20
    "end",
    "rem",
    "allcaps",
    "assignment",
    "modified_goto",
    "data",
    "read",
    "on",  
    "let",
    "fprint",#30
    "finput",
    "fget",
    "delete",
    "sprint",
    "sinput",
    "sget",
    "rename",
    "say", 
    "braille",
    "off",#40
    "click",
    "rewind",
    "sound",
    "setvol",
    "setfreq",
    "setrate",
    "setpitch",
    "beep", #50
    "lf",
    "setsound",
    "splay",
    "sclear",
    "setpos",
    "pprint",
]

# whiles stack
whiles = []
line_number= 0
wend = 0


def init_offset_table(file, length):
    """create lookup table for line numbers"""
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
        offset_table[line_data_index+4]=str(line_number)
        index=line_data_index+size+1



def get_offset_for_line(dec_number):
    """get the file offset for a given line number"""
    for key in offset_table:
        if offset_table[key] == str(dec_number):
            return key
    return -1



def get_arg(line):
    """Get one argument"""
    argument = ""
    length = line[0]
    line = line[1:]
    for ch in line[:length]:
        argument += chr(ch)
    line = line[length:]
    return [argument, line]


def get_args(line):
    """get a list of args and return parssed"""
    arguments = []
    # how many arguments:
    argv = line[0]
    line = line[1:]

    argument = ""
    for i in range(argv):
        argument, line = get_arg(line)
        arguments.append(argument)
    return [arguments, line]

def error_func(line):
    return [cmds[line[0]], line[1:]]


def print_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def input_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    if len(arguments) > 1 and re.match(r'^".*"$',arguments[0]):
        parsed_line +=arguments[0]+"; "
        arguments=arguments[1:]
    
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def if_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]

    argument, line = get_arg(line)
    parsed_line += argument
    return [parsed_line, line]


def then_func(line):
    return [cmds[line[0]], line[1:]]


def else_func(line):
    return [cmds[line[0]], line[1:]]


def goto_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]

    target_count = line[0]  # seems to be always 1 on goto
    line = line[1:]

    line_number = line[0]
    line = line[1:]
    if line:
        line_number += line[0] * 256
        line = line[1:]

    try:
        line_number = offset_table[line_number]
    except:
        line_number = "Error"
    
    jump_lines.append(line_number)
    parsed_line += line_number
    return [parsed_line, line]


def gosub_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]

    target_count = line[0]  # seems to be always 1 on goto
    line = line[1:]
    for count in range(target_count):
        line_number = line[0]
        line = line[1:]
        
        if line:
            line_number += line[0] * 256
            line = line[1:]

        try:
            line_number = offset_table[line_number]
        except:
            line_number = "Error"
        
        jump_lines.append(line_number)
        parsed_line += line_number + ", "

    return [parsed_line.strip(", "), line]


def return_func(line):
    return [cmds[line[0]], line[1:]]


def dim_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]

    # How many Variables
    target_count = line[0]
    line= line[1:]

    for count in range(target_count):
        #variable name length
        length = line[0]
        line = line[1:]

        # variable name 
        name = ""
        for i in range(length):
            name+=chr(line[0])
            line = line[1:]
        parsed_line += name+"("


        sp = ""
        while line[0] != 0:
            #dim_length 
            length = line[0]
            line = line[1:]

            # demention
            num = ""
            for i in range(length):
                num += chr(line[0])
                line = line[1:]
            parsed_line += (sp +num)

            sp = ","

        #ending 0
        sp = ""
        line = line[1:]
        parsed_line += "), "

    parsed_line = parsed_line.strip(", ")
    return [parsed_line, line]



def get_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]

    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def for_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]

    argument, line = get_arg(line)
    parsed_line += argument + " "
    
    parsed_line += " = "
    argument, line = get_arg(line)
    parsed_line += argument + " "

    #consume to statement if there
    if line[0] == 12:
        line = line[1:]
        parsed_line += "to "
    
    argument, line = get_arg(line)
    parsed_line += argument + " "

    #consume step statement if it is there.
    if line and line[0]  == 13:
        line = line[1:]
        parsed_line += "step "

        #get step 
        argument, line = get_arg(line)
        parsed_line += argument + " "

    return [parsed_line, line]




    argument, line = get_arg(line)
    parsed_line += argument + " "

    return [parsed_line, line]


def next_func(line):
    parsed_line = cmds[line[0]]+" "
    line = line[2:]


    argument, line = get_arg(line)
    parsed_line += argument

    return [parsed_line, line]


def while_func(line):
    parsed_line = "if "
    line = line[1:]

    argument, line = get_arg(line)
    parsed_line += argument 
    
    line = b"\x04\x18\x08wh_count\x011" + line
    whiles.append(f"goto {line_number}")
    #print(f"{line_number}: {whiles[-1]}")
    return [parsed_line, line]


def wend_func(line):
    global wend
    if whiles:
        parsed_line = whiles.pop()
        wend = parsed_line.split(" ")[1]
    else:
        parsed_line = "wend"
    return [parsed_line, line[1:]]


def open_func(line):
    parsed_line = cmds[line[0]]+" "
    line = line[1:]

    arguments, line = get_args(line)
    sep = ""
    while arguments:
        parsed_line += f"{sep}{arguments[1]} AS #{arguments[0]}"
        arguments = arguments[2:]
        sep = ": "

    return [parsed_line, line]

def close_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def clear_func(line):
    return ["ERASE", line[1:]]


def create_func(line):
    return [cmds[line[0]], ""]


def end_func(line):
    return [cmds[line[0]], line[1:]]


def rem_func(line):
    return [cmds[line[0]], line[1:]]


def allcaps_func(line):
    return [cmds[line[0]], line[1:]]


def data_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def read_func(line):
    parsed_line = cmds[line[0]]+ " "
    line = line[1:]
    
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    
    return [parsed_line , line]


def on_func(line):
    return [cmds[line[0]], ""]


def let_func(line):
    return [cmds[line[0]], ""]


def fprint_func(line):
    return [cmds[line[0]], ""]


def finput_func(line):
    parsed_line = "INPUT #"
    line = line[1:]
    
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def fget_func(line):
    parsed_line = "GET "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def delete_func(line):
    return [cmds[line[0]], ""]


def sprint_func(line):
    return [cmds[line[0]], ""]


def sinput_func(line):
    return [cmds[line[0]], ""]


def sget_func(line):
    return [cmds[line[0]], ""]


def rename_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def say_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def braille_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def off_func(line):
    return [cmds[line[0]], line[1:]]


def click_func(line):
    return [cmds[line[0]], line[1:]]


def rewind_func(line):
    return ["RESTORE", line[1:]]


def sound_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def setvol_func(line):
    return [cmds[line[0]], ""]


def setfreq_func(line):
    return [cmds[line[0]], ""]


def setrate_func(line):
    return [cmds[line[0]], ""]


def setpitch_func(line):
    return [cmds[line[0]], ""]


def beep_func(line):
    return [cmds[line[0]], line[1:]]


def lf_func(line):
    return [cmds[line[0]], line[1:]]


def setsound_func(line):
    parsed_line = cmds[line[0]] + " "
    line = line[1:]
    arguments, line = get_args(line)
    parsed_line += ", ".join(arguments)
    return [parsed_line, line]


def splay_func(line):
    return ["PLAY", line[1:]]


def sclear_func(line):
    return ["EMPTY", line[1:]]


def setpos_func(line):
    return [cmds[line[0]], ""]


def pprint_func(line):
    return [cmds[line[0]], ""]


def assignment_func(line, then = ""):
    """Deals with Variable assignment statements."""
    parsed_line = then+""

    if then =="":
        # consume the assignment code 24
        line = line[1:]

    # now consume two arguments with the  lengths first
    length = line[0]
    line = line[1:]

    for i in range (length):
        parsed_line += chr(line[0])
        line = line[1:]

    parsed_line += " = "

    length = line[0]
    line = line[1:]
    for i in range(length):
        parsed_line += chr(line[0])
        line=line[1:]

    return [parsed_line, line]

    pass


def modified_goto_func(line):
    return goto_func(line)


parse_functions = {
    "print": print_func,
    "input": input_func,
    "if": if_func,
    "then": then_func,
    "else": else_func,
    "goto": goto_func,
    "gosub": gosub_func,
    "return": return_func,
    "dim": dim_func,
    "get": get_func,
    "for": for_func,
    "next": next_func,
    "while": while_func,
    "wend": wend_func,
    "open": open_func,
    "close": close_func,
    "clear": clear_func,
    "create": create_func,
    "end": end_func,
    "rem": rem_func,
    "allcaps": allcaps_func,
    "data": data_func,
    "read": read_func,
    "on": on_func,
    "let": let_func,
    "fprint": fprint_func,
    "finput": finput_func,
    "fget": fget_func,
    "delete": delete_func,
    "sprint": sprint_func,
    "sinput": sinput_func,
    "sget": sget_func,
    "rename": rename_func,
    "say": say_func,
    "braille": braille_func,
    "off": off_func,
    "click": click_func,
    "rewind": rewind_func,
    "sound": sound_func,
    "setvol": setvol_func,
    "setfreq": setfreq_func,
    "setrate": setrate_func,
    "setpitch": setpitch_func,
    "beep": beep_func,
    "lf": lf_func,
    "setsound": setsound_func,
    "splay": splay_func,
    "sclear": sclear_func,
    "setpos": setpos_func,
    "pprint": pprint_func,
    "assignment": assignment_func,
    "modified_goto": goto_func,"error": error_func
}


