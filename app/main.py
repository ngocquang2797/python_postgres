import argparse
import sys

from pgsql.core import dataLoader

def parse_args():
    parser = argparse.ArgumentParser("Import data from csv to postgresDB")
    parser.add_argument("-p", "--path", type=str, help="path to .csv files")
    parser.add_argument("-n", "--name_table", type=str, help="set name to table")
    parser.add_argument("-m", "--mode", type=str, default="append", help="append: apppend if existed \nreplace: replace")
    parser.add_argument("-t", "--type", type=str, default="csv",
                        help="type of data file")
    parser.add_argument('-c', '--columns', action='store', dest='alist',
                        type=str, nargs='*', default=[],
                        help="Special column\nExamples: -c fid wd19nm, -c lad19cd")
    args = parser.parse_args(args=None if sys.argv[1:] else ['--help'])

    return parser.parse_args()

def main():
    args = parse_args()
    if args.path == None and args.tablename == None:
        args.parse_args(args=None if sys.argv[1:] else ['--help'])

    else:
        cv = dataLoader()
        cv.pg_load_table(args.path, args.name_table, args.mode, args.alist, args.type)

if __name__ == "__main__":
    main()