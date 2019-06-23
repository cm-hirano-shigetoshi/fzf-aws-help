import sys
import shlex
buf = sys.argv[2]
pos = int(sys.argv[1])


def get_cur_element_index(elements, pos):
    end_pos = 0
    for i, element in enumerate(elements):
        if i > 0:
            end_pos += 1
        end_pos += len(element)
        if pos < end_pos:
            return i
    return len(elements)


def get_target_file_name(buf, pos):
    elements = shlex.split(buf)
    pos -= len(buf) - len(" ".join(elements))
    cur_element_index = get_cur_element_index(elements, pos)

    if cur_element_index > 0 and elements[cur_element_index].startswith(
            '<') and elements[cur_element_index].endswith('>'):
        service = elements[1]
        subcmd = elements[2]
        argument = elements[cur_element_index - 1]
    return "{}_{}_{}".format(argument, service, subcmd)


target_file_name = get_target_file_name(buf, pos)
print(target_file_name)
