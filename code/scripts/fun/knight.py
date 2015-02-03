#!/usr/bin/env python2.7
import sys

# fill up chessboard with 0s
sizeboard = 8
chessboard = [[0 for x in range(sizeboard)] for x in range(sizeboard)]

# function to print chessboard as grid
def print_board():
    for row in chessboard:
        for square in row:
            print "%s\t" % square,
        print
        print
    print

def print_string():
    for row in chessboard:
        for square in row:
            print "%s" % square,
    print

# all possible moves the knight can make
moves = {   0 : (-2, -1),
            1 : (-1, -2),
            2 : ( 1, -2),
            3 : ( 2, -1),
            4 : ( 2, 1),
            5 : ( 1, 2),
            6 : ( -1, 2),
            7 : ( -2, 1) 
}

# return true if pos x y on chessboard is not 0
def is_marked(loc):
    global chessboard
    return chessboard[loc[0]][loc[1]]

# set pos x y on chessboard to 1 or second param
def mark_square(loc, unmark=1):
    global chessboard
#    print 'marking %d and %d' % (loc[0], loc[1])
    chessboard[loc[0]][loc[1]] = unmark


# move knight from pos x y to direction and mark square
def move_knight(loc, direction):
#    mark_square(loc, True)
    course = moves[direction]
    newx = loc[0] - course[0]
    newy = loc[1] - course[1]
    newloc = (newx, newy)

    # check if new position is still inside board or already marked
    if  (   newx >= sizeboard 
            or newx < 0 
            or newy >= sizeboard 
            or newy < 0
            or is_marked(newloc)
        ):
        return loc
    else:
        global backtrack;
        mark_square(newloc, len(backtrack) + 1)
        return newloc

# returns true if all cells are not 0
def check_full():
    global squaresleft 
    return True if squaresleft < 2 else False

def step_back():
    global cur, move, backtrack, squaresleft
    previous = backtrack[-1]
    cur = previous[0]
    mark_square(cur, 0)

    backtrack.pop()
    squaresleft += 1

    if len(backtrack) < 2:
        print 'end of search'
        exit()
        return 1

    if (backtrack[-1][1] < 7):
        backtrack[-1][1] += 1
        move = backtrack[-1][1]
    else: 
        step_back()

tours = [];
def hash_tour(tour):
    string = '';
    for row in chessboard:
        for square in row:
            string += str(square)
    return hash(string)

def save_tour(tour):
    global tours;
    tours.append(hash_tour(tour))

def already_saved(tour):
    global tours;
    inlist = False
    string = hash_tour(tour) 
    for saved in tours:
        if (string == saved):
            inlist = True
    return inlist


def do_step():
    global posnew, cur, move, squaresleft, backtrack, chessboard
    posnew = move_knight(cur, move)
    if (cur == posnew):
        tourcomplete = check_full();
        if (tourcomplete): 
            if (not already_saved(chessboard)):
                save_tour(chessboard)
                print_board()
        if (move > 6 or tourcomplete):
            step_back()
        else: 
            move += 1
    else:
        cur = posnew
        move = 0
        backtrack.append([cur, move])
        squaresleft -= 1
    return 0

# set start position and mark first square
start = (0, 0)
cur = start
move = 0
mark_square(cur)

squaresleft = sizeboard * sizeboard

# create list for all steps taken
backtrack = list()
backtrack.append([cur, move])

for i in range(100000000):
    if (do_step()):
        break
