#!/usr/bin/env python
import collections
import datetime
import os
import sys
from itertools import izip

# python stats_gitlog.py --other_file legacy_gitlog

COMMITS = 0
ACTIVE_DAYS = 1

def grouped(iterable, n):
    return izip(*[iter(iterable)]*n)

def print_activity(dic, display, total_commits, total_active_days):
    header = "{0:20} | commits   | active days".format(display)
    print "\n{0}\n".format(header), '-' * len(header)
    for name, data  in dic.items():
        print '{0:20} | {1:>3} | {2:<2}% | {3:<2} | {4:<2}%'.format(name, data[COMMITS], data[COMMITS]*100/total_commits, data[ACTIVE_DAYS], data[ACTIVE_DAYS]*100/total_active_days)

def find_real_author(author):
    assoc = {
        'tbadaud': ['badaud', 'thomas', 'tbadaud', 'badaud_t'],
    }
    for realname, names in assoc.items():
        for name in names:
            if author.lower().find(name) != -1:
                return realname
    return author

def main(other_file=None):
    if other_file:
        os.system("grep -E '^(Date|Author)' '{0}' > __gitstats_activedate__".format(other_file))

    os.system("git log | grep -E '^(Date|Author)' >> __gitstats_activedate__")
    contents = []
    with open("__gitstats_activedate__", "r") as f:
        contents = f.readlines()

    total_commits = 0
    days = {} #collections.OrderedDict()
    for author_line, date_line in grouped(contents, 2):
        date_array = date_line.split(' ')
        date_string = "{0} {1:02} {2}".format(date_array[4], int(date_array[5]), date_array[7])
        date = datetime.datetime.strptime(date_string, '%b %d %Y')

        author = ' '.join(author_line.split(' ')[1:-1])
        author = find_real_author(author)

        if not date in days:
            days[date] = {}
        if not author in days[date]:
            days[date][author] = 0
        days[date][author] += 1

        total_commits += 1

    last_month = -1
    total_active_days = 0
    commiters_activity = collections.OrderedDict()
    months_activity = collections.OrderedDict()
    print "\ndays activity"
    for date, authors in sorted(days.items(), key=lambda t: t[0]):
        if date.month != last_month: print ""
        last_month = date.month

        day_commits = 0
        for author, commits in authors.items():
            if not author in commiters_activity:
                commiters_activity[author] = [0, 0]
            commiters_activity[author][COMMITS] += commits
            commiters_activity[author][ACTIVE_DAYS] += 1
            day_commits += commits

        print '{0:%y/%m/%d}: {1:<3}: {2}'.format(date, day_commits, authors)

        total_active_days += 1

        _ = '{0:%y/%m}'.format(date)
        if not _ in months_activity:
            months_activity[_] = [0, 0]
        months_activity[_][COMMITS] += day_commits
        months_activity[_][ACTIVE_DAYS] += 1

    total_day = days.items()[0][0] - days.items()[-1][0]
    print "\ntotal_commits: {0}\nactives days : {1} (sur {2})".format(total_commits, total_active_days, total_day)

    print_activity(months_activity, 'month', total_commits, total_active_days)
    print_activity(commiters_activity, 'user', total_commits, total_active_days)

    os.system("rm __gitstats_activedate__")


if __name__ == '__main__':
    main()
