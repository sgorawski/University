def pos_of_symbol(symbol):
    return ord(symbol[0]) - ord('a'), int(symbol[1]) - 1


def symbol_of_pos(x, y):
    return f"{chr(x + ord('a'))}{y + 1}"


def describe_action(piece_name, before, after):
    return f'{piece_name} {symbol_of_pos(*before)} -> {symbol_of_pos(*after)}'


def any_king_next_positions(king):
    x, y = king
    for new_x, new_y in (
            (x + 1, y + 1),
            (x + 1, y),
            (x + 1, y - 1),
            (x, y - 1),
            (x - 1, y - 1),
            (x - 1, y),
            (x - 1, y + 1),
            (x, y + 1),
    ):
        if 0 <= new_x <= 7 and 0 <= new_y <= 7:
            yield new_x, new_y


def can_king_beat(king, piece):
    return piece in any_king_next_positions(king)


def can_rook_beat(rook, piece):
    if rook == piece:
        return False
    return piece[0] == rook[0] or piece[1] == rook[1]


def black_king_movements(white_king, white_rook, black_king):
    for new_pos in any_king_next_positions(black_king):
        if (
                not can_king_beat(white_king, new_pos)
                and not can_rook_beat(white_rook, new_pos)
        ):
            if new_pos == white_rook:
                yield (
                    (white_king, (-1, -1), new_pos),
                    describe_action('beat rook', black_king, new_pos)
                )
            else:
                yield (
                    (white_king, white_rook, new_pos),
                    describe_action('black king', black_king, new_pos)
                )


def white_king_movements(white_king, white_rook, black_king):
    if white_king == (-1, -1):
        return
    for new_pos in any_king_next_positions(white_king):
        if (
                not can_king_beat(black_king, new_pos)
                and new_pos != white_rook
        ):
            yield (
                (new_pos, white_rook, black_king),
                describe_action('white king', white_king, new_pos)
            )


def white_rook_movements(white_king, white_rook, black_king):
    if white_rook == (-1, -1):  # is dead
        return
    x, y = white_rook

    # horizontal movement
    if y == white_king[1] and x < white_king[0]:
        horizontal = range(white_king[0])
    elif y == white_king[1]:
        horizontal = range(white_king[0] + 1, 8)
    else:
        horizontal = range(8)

    # vertical movement
    if x == white_king[0] and y < white_king[1]:
        vertical = range(white_king[1])
    elif x == white_king[0]:
        vertical = range(white_king[1] + 1, 8)
    else:
        vertical = range(8)

    # movement by (0, 0) is repeated, shouldn't matter
    for new_x in horizontal:
        yield (
            (white_king, (new_x, y), black_king),
            describe_action('white rook', white_rook, (new_x, y))
        )
    for new_y in vertical:
        yield (
            (white_king, (x, new_y), black_king),
            describe_action('white rook', white_rook, (x, new_y))
        )


def is_checkmate(state):
    return not list(black_king_movements(*state[1]))


def get_next_states(state):
    player, board = state
    if player == 'white':
        for new_board, action in white_king_movements(*board):
            yield ('black', new_board), action
        for new_board, action in white_rook_movements(*board):
            yield ('black', new_board), action
    else:
        for new_board, action in black_king_movements(*board):
            yield ('white', new_board), action


def get_initial_state(text):
    player, *board_raw = text.split()
    board = tuple(pos_of_symbol(s) for s in board_raw)
    return player, board
