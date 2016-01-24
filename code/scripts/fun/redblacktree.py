#!/usr/bin/env python
import random, string

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
    make_right_child(node, new_top.left)

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

    make_left_child(node, new_top.right)

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
#print 'left leaning tree'
#print tree_keys(left_leaning_tree)
right_leaning_tree = create_right_configuration()
#print 'right leaning tree'
#print tree_keys(right_leaning_tree)

# make sure left leaning tree is different from right leaning tree
assert tree_keys(left_leaning_tree) != tree_keys(right_leaning_tree)

right_rotate(left_leaning_tree, left_leaning_tree.root)
#print 'right rotated left leaning tree'
#print tree_keys(left_leaning_tree)
assert tree_keys(left_leaning_tree) == tree_keys(create_right_configuration())

left_rotate(right_leaning_tree, right_leaning_tree.root)
#print 'left rotated right leaning tree'
#print tree_keys(right_leaning_tree)
assert tree_keys(right_leaning_tree) == tree_keys(create_left_configuration())

def is_left_child(node):
    return node == node.parent.left

def is_right_child(node):
    return not is_left_child(node)

def rb_insert_fixup(tree, node):
    while node.parent and node.parent.color and node.parent.parent:
        if is_left_child(node.parent):
            y = node.parent.parent.right
            if y and y.color:
                print 'c1'
                node.parent.color = False
                y.color = False
                node.parent.parent.color = True
                node = node.parent.parent
            else:
                print 'c2'
                if is_right_child(node):
                    node = node.parent
                    left_rotate(tree, node)
                node.parent.color = False
                node.parent.parent.color = True
                right_rotate(tree, node.parent.parent)
        else:
            y = node.parent.parent.left
            if y and y.color:
                print 'c3'
                node.parent.color = False
                y.color = False
                node.parent.parent.color = True
                node = node.parent.parent
            else:
                print 'c4'
                if is_left_child(node):
                    node = node.parent
                    right_rotate(tree, node)
                node.parent.color = False
                node.parent.parent.color = True
                left_rotate(tree, node.parent.parent)
    tree.root.color = False

def make_children_sentinels(node):
    node.left = None
    node.right = None
                
def find_leaf(x, key):
    # loop until x is the leaf of the tree where the key should go and y is the parent
    y = None
    while x:
        y = x
        if key < x.key:
            print '%s goes left of %s' % (key, x.key)
            x = x.left
        else:
            print '%s goes right of %s' % (key, x.key)
            x = x.right
    return y

def rb_insert(tree, node):
    # initialize pointer to None
    x = tree.root
    y = find_leaf(x, node.key)
    node.parent = y
    if not y:
        tree.root = node
    elif node.key < y.key:
        print 'inserting key to the left'
        y.left = node
    else:
        print 'inserting key to the right'
        y.right = node
    make_children_sentinels(node)
    node.color = True
    print 'tree after inserting new node'
    print tree_keys(empty_tree)
    rb_insert_fixup(tree, node)
    print 'tree after rb insert fixup'
    print tree_keys(empty_tree)

left_leaning_tree = create_left_configuration()


empty_tree = Tree()


def add_new_to_tree():
    new_node = Node(key=random.choice(string.ascii_letters))
    rb_insert(empty_tree, new_node)

def node_height(node, l=0):
    hl = node_height(node.left, l+1) if (node and node.left) else l
    hr = node_height(node.right, l+1) if (node and node.right) else l
    nh = hl if hl > hr else hr
    return nh

def node_is_balanced(node):
    if not node:
        return True
    else:
        l_balanced = node_is_balanced(node.left)
        r_balanced = node_is_balanced(node.right)
        hl = node_height(node.left)
        hr = node_height(node.right)
        hb = abs((hl - hr) <= 1)
        return bool (l_balanced and r_balanced and hb)

for i in range(0, 10):
    balanced_tree = node_is_balanced(empty_tree.root)
    print 'tree is balanced or not: %s' % balanced_tree
    assert balanced_tree
    add_new_to_tree()
