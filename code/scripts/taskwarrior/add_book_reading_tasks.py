import argparse
from taskw import TaskWarrior
w = TaskWarrior()


def add_range_task(project, title, start, end, depends):
    added_task = w.task_add("%s %d-%d" % (title, start, end), project=project, depends=depends)
    return added_task['uuid']

def add_task_range(project, title, start, end, size):
    total = end - start

    old_pos = start
    new_pos = int()
    depends = None
    while new_pos < end:
        new_pos = old_pos + size
	new_pos = new_pos if new_pos < end else end
        depends = add_range_task(project, title, old_pos, new_pos, depends)
        old_pos = new_pos

def add_book_tasks(title, start, end):
    add_task_range("reading", title, start, end, 60)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("title", help="Title of the book you're reading")
    parser.add_argument("start", help="Page number you're at", type=int)
    parser.add_argument("end", help="Last page number of the book", type=int)
    args = parser.parse_args()

    add_book_tasks(args.title, args.start, args.end)

main()
