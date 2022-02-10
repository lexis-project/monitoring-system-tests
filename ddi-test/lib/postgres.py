import psycopg2
import json
import logging


def get_database_info(file):
    with open(file, 'r') as f:
        machines = json.load(f)
        print(machines["Databases"])
    return machines["Databases"]
def connect(db):
    """ Connect to the PostgreSQL database server """
    database = db.get("database")
    user= db.get("user")
    password = db.get("password")
    hosts = db.get("hosts")
    conn = None
    for host in hosts:
        try:
            # read connection parameters
            params = db

            # connect to the PostgreSQL server
            logging.info('Connecting to the PostgreSQL database '+host+' ...')
            conn = psycopg2.connect(host=host,database=database, user=user, password=password)

            # create a cursor
            cur = conn.cursor()

            # execute a statement
            logging.info('PostgreSQL database version:')
            cur.execute('SELECT version()')

            # display the PostgreSQL database server version
            db_version = cur.fetchone()
            logging.info(db_version)

            # close the communication with the PostgreSQL
            cur.close()
        except (Exception, psycopg2.DatabaseError) as error:
            logging.info(error)
        finally:
            if conn is not None:
                conn.close()
                logging.info('Database connection test is successful.Database connection will be closed.')