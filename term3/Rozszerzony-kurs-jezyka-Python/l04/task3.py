def correct(line):
    start_index = 0
    end_index = len(line)

    while not line[start_index].isalnum():
        start_index += 1
    while (line[end_index - 1] not in ['.', '!', '?']
           and not line[end_index - 1].isalnum()
           and end_index > 1):
        end_index -= 1
    if line[end_index - 1] not in ['.', '!', '?']:
        line = line[:end_index] + '.'
        end_index += 1

    return line[start_index].upper() + line[start_index + 1:end_index]


def sentences(stream):
    for line in stream:
        yield correct(line)
