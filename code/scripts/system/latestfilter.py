#!/usr/bin/env python
# WARNING: this script removes the directory specified with the -t flag if it exists.
# Make sure you specify a new and temporary directory to prevent accidental data loss. 

import sys, getopt, os, shutil
from operator import itemgetter

abspath     = lambda x: os.path.abspath(x)      # get absolute path
dirname     = lambda x: os.path.dirname(x)      # get directory file is in 
listfiles   = lambda x: os.walk(abspath(x))     # get tuples of all files with root, directory and filename
stitch      = lambda x, y: os.path.join(x, y)   # function to join root and filename

# function to create list of absolute file paths in origin dir
def absfilelist(dp):
    absfiles = []
    for r, d, fs in listfiles(dp):
    	for f in fs:
    		absfiles.append(stitch(r, f))
    return absfiles

modlist     = lambda i: map(os.path.getmtime, i)        # get modification time for each item in iterable
sizlist     = lambda i: map(os.path.getsize, i)         # get filesize for each item in iterable 
# with absolute file path list as input zip together the lists
combine     = lambda i: zip(i, sizlist(i), modlist(i))  # 
# create a list of tuples with the absolute path, file size and modification time
filedat         = lambda x: combine(absfilelist(x)) 
# sort that list of tuples based on modification date (newest first)
filedat_by_time = lambda x: sorted(filedat(x), key=itemgetter(2), reverse=True)

def symlink(p, np):
    try:
        os.symlink(p, np)
    except OSError:
        pass
    
def mkdirp(p):
    try:
        os.makedirs(p)
    except OSError:
        pass

def writesymlinks(p, np): 
        newpathdir  = dirname(np)
        # create all underlying directories if they don't exist yet
        mkdirp(newpathdir)
        # create the actual symlink in the destination folder
        symlink(p, np)
        global VERBOSE
        if VERBOSE: 
            print "symlinking " + np

# function to check if there is space left
spaceleft  = lambda x, y: (x - y) > 0

def fill_latest(op, dp, al): 
    # get tuple with all files in origin dir together with file size and sorted on mtime
    dat = filedat_by_time(op)
    # check if there are items left in the file list and see if they fit in the allocated space
    while dat and spaceleft(al, dat[0][1]):
        al          -= dat[0][1]
        path        = dat.pop(0)[0]
        newpath     = dp + '/' + path.replace(op, '').lstrip('/')
        writesymlinks(path, newpath)
        
def clear_destpath(dp):
    if os.path.exists(dp):
    	if VERBOSE:
	    	print "removing existing directory: " + dp
    	shutil.rmtree(dp);

def usage():
    print "Usage:   -f [origin dir] -t [destination dir] -a [allocated space in bytes]"
    print "Exampe:  ./latest -f folder1 -t folder2 -a 40000000"

VERBOSE     = False
def main():
    ORIGPATH    = False
    DESTPATH      = False
    ALLOCATED   = False

    # getopts to handle arguments
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hf:t:a:v", ["help"])
    except getopt.GetoptError as e:
        print str(e)  
        usage()
        sys.exit(2)
    for o, a in opts:
        if o == "-f":
            ORIGPATH = abspath(a)
        elif o == "-t":
            DESTPATH = a
        elif o == "-a":
            ALLOCATED = int(a)
        elif o == "-v":
            global VERBOSE
            VERBOSE = True
        elif o in ("-h", "--help"):
            usage()
        else:
            assert False, "unhandled option"
    
    if DESTPATH is '/' or abspath(DESTPATH) is '/':
    	print "Destination path is '/'. You probably don't want to do that"
    	sys.exit(2)
    # check if all necesarry input is accounted for
    if ORIGPATH and DESTPATH and ALLOCATED > 0: 
        clear_destpath(DESTPATH)
        fill_latest(ORIGPATH, DESTPATH, ALLOCATED)
    else: 
        usage()

main();
