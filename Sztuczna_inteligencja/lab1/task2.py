subresults = None


def find_opt_word_break(text, dictionary):
    if text == '':
        return 0, []
    if len(text) in subresults:
        return subresults[len(text)]
    
    best_prefix, best_rest = '', None
    best_rest_sum_sq = -1
    for i in range(1, len(text) + 1):
        prefix = text[:i]
        if prefix in dictionary:
            sum_len_rest_sq, rest = find_opt_word_break(text[i:], dictionary)
            if sum_len_rest_sq != -1:
                if len(prefix) ** 2 + sum_len_rest_sq > len(best_prefix) ** 2 + best_rest_sum_sq:
                    best_rest_sum_sq = sum_len_rest_sq
                    best_prefix, best_rest = prefix, rest
    
    if not best_prefix:
        return -1, None
    
    res = len(best_prefix) ** 2 + best_rest_sum_sq, [best_prefix, *best_rest]
    subresults[len(text)] = res
    return res 


if __name__ == '__main__':
    with open('zad2_input.txt', 'r') as in_, \
            open('zad2_output.txt', 'w+') as out, \
            open('words_for_ai1.txt', 'r') as words:
        dictionary = set(w[:-1] for w in words if w)
        for line in in_:
            subresults = {}
            _, ans = find_opt_word_break(line[:-1], dictionary)
            out.write(f'{" ".join(ans)}\n')
