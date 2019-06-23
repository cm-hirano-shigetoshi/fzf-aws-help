import os
import sys
import re
import shlex
import subprocess
from subprocess import PIPE


def filter_with_fzf(paths):
    cmd = ' '.join([
        'fzfer run',
        os.environ.get("FZF_AWS_HELP_RESOURCE_HOME") + '/filter_resources.yml',
        paths[0], paths[1]
    ])
    proc = subprocess.run(cmd, shell=True, stdout=PIPE)
    stdout = re.sub(r'\s+$', '', proc.stdout.decode('utf8'))
    return stdout


def get_file_paths_of(basename):
    input_file = "{}/commands/input_{}".format(
        os.environ.get("FZF_AWS_HELP_RESOURCE_HOME"), basename)
    result_file = "{}/{}/result{}".format(
        os.environ.get("FZF_AWS_HELP_RESOURCE_RESULT_DIR"),
        os.environ.get("AWS_PROFILE", "default"), basename)
    if os.path.exists(input_file):
        return [input_file, result_file]
    else:
        return None


def get_file_paths(service, subcmd, method):
    paths = None
    basename = "{}_{}_{}".format(method, service, subcmd)
    while basename.find("_") >= 0:
        paths = get_file_paths_of(basename)
        if paths is not None:
            break
        basename = basename[:basename.rfind("_")]
    return paths


def expand(elements, index):
    if index < -1:
        return ["", ""]
    service = elements[1]
    subcmd = elements[2]
    method = elements[index - 1]
    paths = get_file_paths(service, subcmd, method)
    if paths is None:
        return ["", ""]
    got_string = filter_with_fzf(paths)
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
if elements[index-1].startswith('--'):
    [new_pos, new_buf] = expand(elements, index)
    print(new_pos)
    print(new_buf)
