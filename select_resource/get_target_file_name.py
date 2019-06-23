import os
import sys
import re
import shlex
import subprocess
from subprocess import PIPE


def select_resources(input_cmd):
    proc = subprocess.run(
        input_cmd + " | fzf -m --reverse", shell=True, stdout=PIPE)
    stdout = re.sub(r'\s+$', '', proc.stdout.decode('utf8'))
    return stdout


def get_result_file_of(basename):
    input_file = "{}/commands/input_{}".format(
        os.environ.get("FZF_AWS_HELP_RESOURCE_HOME"), basename)
    result_file = "{}/{}/result{}".format(
        os.environ.get("FZF_AWS_HELP_RESOURCE_RESULT_DIR"),
        os.environ.get("AWS_PROFILE", "default"), basename)
    if not os.path.exists(input_file):
        return ""
    if not os.path.exists(result_file):
        with open(input_file, "r") as f:
            cmd = "\n".join(f.readlines())
            cmd = re.sub(r'\s+$', '', cmd)
        with open(result_file, "w") as f:
            proc = subprocess.run(cmd, shell=True, stdout=PIPE)
            f.write(re.sub(r'\s+$', '', proc.stdout.decode('utf8')))
    return "cat " + result_file


def get_result_file(service, subcmd, method):
    result_file = ""
    basename = "{}_{}_{}".format(method, service, subcmd)
    while basename.find("_") >= 0:
        result_file = get_result_file_of(basename)
        if result_file != '':
            break
        basename = basename[:basename.rfind("_")]
    return result_file


def expand(elements, index):
    if index < -1:
        return ["", ""]
    service = elements[1]
    subcmd = elements[2]
    method = elements[index - 1]
    result_file = get_result_file(service, subcmd, method)
    if result_file == '':
        return ["", ""]
    got_string = select_resources(result_file)
    if got_string == '':
        return ["", ""]
    elements[index] = got_string
    new_buf = " ".join(elements)
    if index == len(elements) - 1:
        new_pos = len(new_buf)
    else:
        new_pos = len(" ".join(elements[:index + 1]))
    return [new_pos, new_buf]


def get_cur_element_index(elements, pos):
    end_pos = 0
    for i, element in enumerate(elements):
        if i > 0:
            end_pos += 1
        end_pos += len(element)
        if pos < end_pos:
            return i
    return len(elements)


buf = sys.argv[2]
pos = int(sys.argv[1])

elements = shlex.split(buf)
pos -= len(buf) - len(" ".join(elements))
index = get_cur_element_index(elements, pos)
if elements[index].startswith('<') and elements[index].endswith('>'):
    [new_pos, new_buf] = expand(elements, index)
    print(new_pos)
    print(new_buf)
