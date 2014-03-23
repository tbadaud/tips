import os
import argparse
import re
import sys


def yes_no(prompt):
    try:
        q = raw_input(prompt + " [Y/n] ").lower()
    except KeyboardInterrupt: sys.exit(0)
    except EOFError: sys.exit(0)

    if len(q) == 0 or q == "y":
        return True
    return False

def get_next_regex():
    ext = '.*\.(?P<ext>avi|mkv|mp4|srt|ass)'
    regexs = [
        '(s|S)(?P<season>\d{2})( |-)?(E|e)(?P<episode>\d{2})',
        'season (?P<season>\d+)..(?P<episode>\d+)',
    ]

    for r in regexs:
        yield r + ext

    while 1:
        regex = raw_input('custom regex?: ')
        if yes_no('use "{0}"?'.format(regex)) is True:
            yield regex + ext


def rename_series(folder, regex=None):

    def _generate_filename(g):
        return 'S{0:>02}E{1:>02}.{2}'.format(g.group('season'), g.group('episode'), g.group('ext'))

    try:
        ls = os.listdir(folder)
    except Exception as e:
        print e
        return

    for regex in get_next_regex():
        err = False

        for f in ls:
            g = re.search(regex, f)
            if g is None:
                print 'failed: file: "{0}", regex "{1}"'.format(f, regex)
                err = True
                break
            print f, ' => ', _generate_filename(g)

        if err is False:
            print 'ok: "{0}"'.format(regex)
            if yes_no('go with this one?') is True:

                for f in ls:
                    g = re.search(regex, f)
                    os.rename(f, _generate_filename(g))
                return


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('folder', help='folder to work on', type=str)
    parser.add_argument('-r', '--regex', help='use special regex', type=str)
    args = parser.parse_args()
    rename_series(folder=args.folder, regex=args.regex)
