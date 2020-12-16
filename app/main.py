import csv
from glob import iglob
import pandas as pd
from sqlalchemy import create_engine
import numpy as np

import argparse
import sys
import time

def parse_args():
    parser = argparse.ArgumentParser("Import data from csv to postgresDB")
    parser.add_argument("-p", "--path", type=str, help="path to .csv files")
    parser.add_argument("-t", "--tablename", type=str, help="set name to table")
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

    def pg_load_table(self, file_path, table_name):
        try:
            engine = create_engine('postgres://{}:{}@{}:{}/{}'.format(self.user, self.pwd, self.host, self.port, self.dbname))
            count = 0
            for df in pd.read_csv(file_path, chunksize=self.chuck_size):
                df = df.replace(r'^\s*$', np.nan, regex=True)
                df.to_sql(
                    table_name,
                    engine,
                    index=False,
                    if_exists='append'  # if the table already exists, append this data
                )
                if count == 1000000:
                    break
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
        cv.pg_load_table(args.path, args.tablename)

if __name__ == "__main__":
    main()