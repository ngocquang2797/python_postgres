import argparse
import sys

from pgsql.core import dataLoader

def parse_args():
    parser = argparse.ArgumentParser("Import data from csv to postgresDB")
    parser.add_argument("-p", "--path", type=str, help="path to .csv files")
    parser.add_argument("-t", "--tablename", type=str, help="set name to table")
    parser.add_argument("-m", "--mode", type=str, default="append", help="append: apppend if existed \nreplace: replace")
    parser.add_argument('-c', '--columns', action='store', dest='alist',
                        type=str, nargs='*', default=[],
                        help="Special column\nExamples: -i fid wd19nm, -i lad19cd")
    args = parser.parse_args(args=None if sys.argv[1:] else ['--help'])

    return parser.parse_args()

def main():
    args = parse_args()
    if args.path == None and args.tablename == None:
        args.parse_args(args=None if sys.argv[1:] else ['--help'])

    else:
        cv = dataLoader()
        cv.pg_load_table(args.path, args.tablename, args.mode, args.alist)

if __name__ == "__main__":
    main()