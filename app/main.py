import csv
from glob import iglob
import pandas as pd
from sqlalchemy import create_engine
import sqlalchemy
import numpy as np

import argparse
import sys
import time

def parse_args():
    parser = argparse.ArgumentParser("Import data from csv to postgresDB")
    parser.add_argument("-p", "--path", type=str, help="path to .csv files")
    parser.add_argument("-t", "--tablename", type=str, help="set name to table")
    parser.add_argument("-m", "--mode", type=str, default="replace", help="append: apppend if existed \nreplace: replace")
    parser.add_argument('-c', '--columns', action='store', dest='alist',
                        type=str, nargs='*', default=[],
                        help="Examples: -i fid wd19nm, -i lad19cd")
    args = parser.parse_args(args=None if sys.argv[1:] else ['--help'])

    return parser.parse_args()

class dataLoader():
    def __init__(self):
        self.dbname = "database"
        self.host = "db"
        self.port = "5432"
        self.user = "username"
        self.pwd = "secret"
        self.chuck_size = 10000

    def file_header(self, file_path):
        unique_headers = set()
        for filename in iglob(file_path):
            with open(filename, 'r') as fin:
                csvin = csv.reader(fin)
                unique_headers.update(next(csvin, []))
                return list(unique_headers)

    def gettype(self, cols):
        types = {}
        for col in cols:
            types[col] = sqlalchemy.types.String()
        return types

    def pg_load_table(self, file_path, table_name, m='replace', colums = None):
        dtypes = self.gettype(colums)
        try:
            engine = create_engine('postgres://{}:{}@{}:{}/{}'.format(self.user, self.pwd, self.host, self.port, self.dbname))
            count = 0
            # read csv chuck by chuck
            for df in pd.read_csv(file_path, chunksize=self.chuck_size):
                # replace space value to nan
                df = df.replace(r'^\s*$', np.nan, regex=True)
                df = df.replace('', np.nan, regex=True)
                # import data to sql
                df.to_sql(
                    table_name,
                    engine,
                    index=False,
                    dtype=dtypes,
                    if_exists=m  # if the table already exists, append this data
                )
                count += self.chuck_size
                print("{0} rows".format(count), end="\r")
            print("Success!!")

        except Exception as e:
            print("Error: {}".format(str(e)))

def main():
    args = parse_args()
    if args.path == None and args.tablename == None:
        args.parse_args(args=None if sys.argv[1:] else ['--help'])

    else:
        cv = dataLoader()
        cv.pg_load_table(args.path, args.tablename, args.mode, args.alist)

if __name__ == "__main__":
    main()