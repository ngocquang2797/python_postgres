import csv
from glob import iglob
import psycopg2

class dataLoader():
    def __init__(self):
        self.dbname = "database"
        self.host = "db"
        self.port = "5432"
        self.user = "username"
        self.pwd = "secret"

    def file_header(self, file_path):
        unique_headers = set()
        for filename in iglob(file_path):
            with open(filename, 'r') as fin:
                csvin = csv.reader(fin)
                unique_headers.update(next(csvin, []))
                return unique_headers

    def pg_load_table(self, file_path, table_name):
        try:
            conn = psycopg2.connect(dbname=self.dbname, host=self.host, port=self.port, user=self.user, password=self.pwd)
            print("Connecting to Database")
            cur = conn.cursor()
            f = open(file_path, "r")
            # Truncate the table first
            cur.execute("Truncate {} Cascade;".format(table_name))
            print("Truncated {}".format(table_name))
            # Load table from the file with header
            cur.copy_expert("copy {} from STDIN CSV HEADER QUOTE '\"'".format(table_name), f)
            cur.execute("commit;")
            print("Loaded data into {}".format(table_name))
            conn.close()
            print("DB connection closed.")

        except Exception as e:
            print("Error: {}".format(str(e)))

def main():
    # unique_headers = set()
    # for filename in iglob('/app/data/local_authority.csv'):
    #     with open(filename, 'r') as fin:
    #         csvin = csv.reader(fin)
    #         unique_headers.update(next(csvin, []))
    #         print(unique_headers)

    db = dataLoader()
    db.pg_load_table('/app/data/lau2_pc_la.csv',"database")

if __name__ == "__main__":
    main()