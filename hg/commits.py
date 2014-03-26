#!/usr/bin/env python
"""
A Mercurial extension that allows the user to commit modified files as multiple
changesets, in a single operation. An editor is invoked with the current list of
modified files, and the user needs to edit the file, adding a single comment
line before each set of lines, separated by some empty lines between each
desired changeset.

Something like this::

    Modified project files.
    HGC:  M docs/flair.txt
    HGC:  M docs/dmping.txt

    Added extra careful tracing and assertions.
    HGC:  M common/lib/pyfff/tracing.py
    HGC:  M common/lib/googoo/logging.c
    HGC:  M common/lib/googoo/strutils.c

    HGC:  M docs/testutils.txt
    HGC:  M common/lib/pyfff/__init__.py
    HGC:  A common/lib/pyfff/testutil
    New test utilities.

Each set will be committed independently when you exit the editor.
"""
# This should work with Mercurial 1.1.

__author__ = 'Martin Blais <blais@furius.ca>'
# CREDITS:
#  - Martin Blais <blais at furius dot ca>: Author.
#  - Andrei Vermel <avermel at mail dot ru>: Backported to Python 2.4.
#  - Martin Kjeldsen" <martin at martinkjeldsen dot dk>: Ported to hg-1.3.

# url http://furius.ca/pubcode/
# stdlib imports
import sys, os, termios, tty, tempfile, datetime, re, logging
from operator import itemgetter
from subprocess import Popen, PIPE, call
from os.path import *

# mercurial imports
from mercurial import hg, cmdutil, util, match
from mercurial.commands import dryrunopts, walkopts, commitopts, commitopts2


# workaround for Python 2.4
def myall(iterable):
    for element in iterable:
        if not element:
            return False
    return True

try:
   if not callable(all):
      all = myall
except:
   all = myall

_pfx = 'HGC:'
_pfx_root = 'ROOT:'


def commits(ui, repo, *pats, **opts):
    node1, node2 = cmdutil.revpair(repo, opts.get('rev'))

    matcher = cmdutil.match(repo, pats, opts)
    cwd = (pats and repo.getcwd()) or ''
    modified, added, removed, deleted, unknown, ignored, clean = \
              repo.status(node1=node1, node2=node2,
                          match=matcher,
                          unknown=True)

    changetypes = (('modified', 'M', modified),
                   ('added', 'A', added),
                   ('removed', 'R', removed),
                   ('deleted', '!', deleted),
                   ('unknown', '?', unknown),
                   )

    end = '\n'
    status_lines = [end]
    status_lines.append("%s %s%s" % (_pfx_root, repo.root, end))
    for opt, char, changes in changetypes:
        format = "%s  %s %%s%s" % (_pfx, char, end)
        for f in changes:
            status_lines.append(format % repo.pathto(f, cwd))

    contents = cmdutil.logmessage(opts)
    if not contents:
        contents = ui.edit("".join(status_lines), opts['user'])

    sets = parse_changesets(contents)
    if sets is None:
        sys.exit(1)

    for i, (message, files) in enumerate(sets):
        print 'Committing set %d' % (i+1)
        print message
        for fn in files:
            print fn
        print

        m = match.match(repo.root, '', files, exact=True)
        if not opts['dry_run']:
            repo.commit(match=m, text=message, user=opts['user'], date=opts['date'], force=util.always)



def split_paragraphs(text):
    "Split the text in paragraphs, return a list of (list of lines)."
    lines = [x.strip() for x in text.splitlines()
             if not re.match(_pfx_root, x)]
    pars, cur = [], []
    for line in lines:
        if not line:
            if cur:
                pars.append(cur)
                cur = []
        else:
            cur.append(line)
    if cur:
        pars.append(cur)
        cur = None
    return pars


sre = re.compile('^%s[ ]+[MARC!?I] (.*)' % _pfx)

def split_comments_and_files(lines):
    "Given a list of lines, split it between comments and filenames."
    comments, files = [], []
    for line in lines:
        mo = sre.match(line)
        if mo:
            files.append(mo.group(1))
        else:
            comments.append(line)
    return comments, files


def parse_changesets(contents):
    """
    Given the text, parse it into a list of changesets, returning pairs of
    (comment, list-of-filenames).
    """
    paragraphs = split_paragraphs(contents)

    rsets = []
    invalid = 0
    for par in paragraphs:
        comments, files = split_comments_and_files(par)
        if not files or not comments:
            print >> sys.stderr, (
                "No comments or files on paragraph:\n%s\n" % '\n'.join(par))
            invalid = 1
            continue

        rsets.append( ('\n'.join(comments), files) )
    if invalid:
       return None
    return rsets


cmdtable = {
    "commits": (commits, dryrunopts + walkopts + commitopts + commitopts2,
                "hg commits [options]")
}





_text = """\
Modified project files.
HGC:  M docs/flair.txt
HGC:  M docs/dmping.txt

Added extra careful tracing and assertions.
HGC:  M common/lib/pyfff/tracing.py
HGC:  M common/lib/googoo/logging.c
HGC:  M common/lib/googoo/strutils.c

HGC:  M docs/testutils.txt
HGC:  M common/lib/pyfff/__init__.py
HGC:  A common/lib/pyfff/testutil
New test utilities.
Right, they are.
"""

_text1 = """\
HGC:  M docs/flair.txt
HGC:  M docs/dmping.txt
"""

def test_paragraphs():
    res = split_paragraphs(_text)
    assert len(res) == 3

    res = split_paragraphs(_text1)
    assert len(res) == 1

def test_changeset1():
    res = parse_changesets(_text)
    assert len(res) == 3

    for (comments, files), nblines in zip(res, (1, 1, 2)):
        assert len(comments.splitlines()) == nblines
        assert files
