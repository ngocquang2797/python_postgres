import csv
from glob import iglob
import pandas as pd
from sqlalchemy import create_engine
import sqlalchemy
import numpy as np
import geopandas as gpd

class Loader():
    def __init__(self):
        self.param_dic = {"host": "db",
                          "database": "database",
                          "port": "5432",
                          "user": "username",
                          "password": "secret"}
        self.chuck_size = 10000

    def gettype(self, cols):
        types = {}
        for col in cols:
            types[col] = sqlalchemy.types.String()
        return types

    def pg_load_table(self, file_path, table_name, m='append', colums=None):
        dtypes = self.gettype(colums)
        try:
            engine = create_engine(
                'postgres://{}:{}@{}:{}/{}'.format(self.user, self.pwd, self.host, self.port, self.dbname))
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

class dataLoader():
    def __init__(self):
        self.dbname = "database"
        self.host = "db"
        self.port = "5432"
        self.user = "username"
        self.pwd = "secret"
        self.chuck_size = 10000

    # return header of csv file
    def file_header(self, file_path):
        unique_headers = set()
        for filename in iglob(file_path):
            with open(filename, 'r') as fin:
                csvin = csv.reader(fin)
                unique_headers.update(next(csvin, []))
                return list(unique_headers)

    # convert data type of columns to string type
    def gettype(self, cols):
        types = {}
        for col in cols:
            types[col] = sqlalchemy.types.String()
        return types

    # import pandas fataframe to sql
    def import_db(self, df, table_name, engine, dtypes, m):
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

    def pg_load_table(self, file_path, table_name, m='replace', colums=None, type='csv'):
        dtypes = self.gettype(colums)
        try:
            engine = create_engine('postgres://{}:{}@{}:{}/{}'.format(self.user, self.pwd, self.host, self.port, self.dbname))
            count = 0
            if type=='csv':
                # read csv chuck by chuck
                for df in pd.read_csv(file_path, chunksize=self.chuck_size):
                    self.import_db(df, table_name, engine, dtypes, m)
                    count += self.chuck_size
                    print("{0} rows".format(count), end="\r")
            else:
            #     read .geojson
                data = gpd.read_file(file_path)
                df = pd.DataFrame(data)
                # pop geometry columns
                df.pop('geometry')
                self.import_db(df, table_name, engine, dtypes, m)
            print("Success!!")

        except Exception as e:
            print("Error: {}".format(str(e)))
