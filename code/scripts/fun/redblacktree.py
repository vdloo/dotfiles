#!/usr/bin/env python

# Red-Black Trees as in chapter 13 of CSLR

# NIL pointer is represented as False
# color: True is red, False is black

def node(key, color=True, left=None, right=None, parent=None):
    return {
        'color': color,
        'key': key,
        'left': left,
        'right': right,
        'parent': parent
    }

class Node(object):
    def __init__(self, key, color=True, left=None, right=None, parent=None):
        self.key = key
        self.color = color
        self.left = left
        self.right = right
        self.parent = parent

class Tree(object):
    def __init__(self):
        self.root = None

def get_nodes_for_values(seq):
    return map(lambda key: Node(key=key), seq)

def make_left_child(parent, child):
    # overwrite left child with new child
    parent.left = child

    # set child's parent if child is not a sentinel Node
    if child:
        child.parent = parent

def make_right_child(parent, child):
    # overwrite right child with new child
    parent.right = child

    # set child's parent if child is not a sentinel Node
    if child:
        child.parent = parent

def create_left_configuration():
    tree = Tree()

    y, x, z, a, b = get_nodes_for_values(['y', 'x', 'z', 'a', 'b'])

    # y is going to be the root of the tree
    tree.root = y

    # defining y's children and and setting the children's parent to y
    make_left_child(y, x)
    make_right_child(y, z)

    # defining x's children and and setting the children's parent to x
    make_left_child(x, a)
    make_right_child(x, b)

    return tree

def create_right_configuration():
    tree = Tree()

    x, a, y, b, z = get_nodes_for_values(['x', 'a', 'y', 'b', 'z'])

    # x is going to be the root of the tree
    tree.root = x

    # defining x's children and and setting the children's parent to x
    make_left_child(x, a)
    make_right_child(x, y)

    # defining y's children and and setting the children's parent to y
    make_left_child(y, b)
    make_right_child(y, z)

    return tree

def left_rotate(tree, node):
    # overwrite node.right with node.right.left but save the pointer to node.right 
    new_top = node.right   # keep a pointer to the right child of node
    make_right_child(node, node.right.left)

    # change new top's parent to original top's parent
    new_top.parent = node.parent
    # if the original top's parent was a sentinel this is now the root of the tree
    if not node.parent:
        tree.root = new_top
    # if the original top was a left child, attach to parent left child slot
    elif node == node.parent.left:
        node.parent.left = new_top
    # if the original top was not left child and not parent, attach to parent right child slot
    else: 
        node.parent.right = new_top
    # set the original top as the new top's left child
    new_top.left = node
    # set the original top's parent as the new top
    node.parent = new_top

def right_rotate(tree, node):
    # overwrite node.left with node.left.right but save the pointer to node.left 
    new_top = node.left   # keep a pointer to the left child of node
    make_left_child(node, node.left.right)

    # change new top's parent to original top's parent
    new_top.parent = node.parent
    # if the original top's parent was a sentinel this is now the root of the tree
    if not node.parent:
        tree.root = new_top
    # if the original top was a left child, attach to parent left child slot
    elif node == node.parent.right:
        node.parent.right = new_top
    # if the original top was not right child and not parent, attach to parent left child slot
    else: 
        node.parent.left = new_top
    # set the original top as the new top's left child
    new_top.right = node
    # set the original top's parent as the new top
    node.parent = new_top

def node_keys(node):
    if node:
        left_keys = node_keys(node.left) if node.left else ''
        right_keys = node_keys(node.right) if node.right else ''
        return node.key + left_keys + right_keys

def tree_keys(tree):
    return node_keys(tree.root)

left_leaning_tree = create_left_configuration()
print 'left leaning tree'
print tree_keys(left_leaning_tree)
right_leaning_tree = create_right_configuration()
print 'right leaning tree'
print tree_keys(right_leaning_tree)

# make sure left leaning tree is different from right leaning tree
assert tree_keys(left_leaning_tree) != tree_keys(right_leaning_tree)

right_rotate(left_leaning_tree, left_leaning_tree.root)
print 'right rotated left leaning tree'
print tree_keys(left_leaning_tree)
assert tree_keys(left_leaning_tree) == tree_keys(create_right_configuration())

left_rotate(right_leaning_tree, right_leaning_tree.root)
print 'left rotated right leaning tree'
print tree_keys(right_leaning_tree)
assert tree_keys(right_leaning_tree) == tree_keys(create_left_configuration())

# todo: implement RB-INSERT
