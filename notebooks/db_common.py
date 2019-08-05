# wrap function to execute single query or a SQL script
import numpy as np
import pandas as pd
import time
from iamconnectioninfo import IamConnection
from pgdb import connect

def get_new_connection():
    iamconnectioninfo = IamConnection()
    return connect(database=iamconnectioninfo.db,
             host=iamconnectioninfo.hostname_plus_port,
             user=iamconnectioninfo.username,
             password=iamconnectioninfo.password) 

default_conn = get_new_connection()

def exec_query(conn, stmt):
    ts_start = time.time()
    df = pd.read_sql(stmt, conn)
    #df.columns = [x.decode('utf-8') for x in df.columns]
    exec_time = time.time() - ts_start
    print('Escaped time: %d seconds, \tReturned rows: %d' % (round(exec_time, 3),  df.shape[0]))
    #colnames = [desc[0] for desc in cur.description]
    return df

def exec_dml(conn, stmt):
    ts_start = time.time()
    cur = conn.cursor()
    exec_time = 0
    try:
        cur.execute(stmt)
        # commit the changes to the database
        conn.commit()
        exec_time = time.time() - ts_start
        print('Escaped time: %d seconds' % round(exec_time, 3))   
    except (Exception) as error:
        print(error)
    finally:
        cur.close()
    return exec_time

def exec_queries(queries, options):
    con = get_new_connection()
    ts_start = time.time()
    
    # execute set options
    cur = con.cursor()
    for op in options:
        print(op)
        cur.execute(op)
    cur.close()
    
    cnt = 0;
    for stmt in queries:
        if len(stmt.strip()) < 1:
            continue
        try:
            pd.read_sql(stmt, con)
        except (Exception) as error:
            print(error)
            pass
        finally:
            pass
        cnt = cnt + 1
        if int(time.time() - ts_start) % 10 == 0:
            print(time.ctime(), 'query completed: %d\n' % cnt)
    
    exec_time = time.time() - ts_start
    print('Escaped time: %d seconds, \tquery executed: %d' % (round(exec_time, 3),  len(queries)))
    
    con.close()
    return exec_time


# Run a set of queries randomly with specified number of threads
def load_testing(scripts, concurrency, cnt):
    from concurrent.futures import ThreadPoolExecutor
    import itertools
    import random
    
    total = cnt     # number of total queries being executed per connection

    Queries = []

    # read queries
    with open(scripts,'r') as script:
        query_stmt = script.read()
        Queries = query_stmt.split(';')

    # randomize queries per execution thread
    TestQueries = []
    for i in range(concurrency):
        qs = []
        list_queries = [random.randrange(0, len(Queries)) for _ in range(total)]
        for q in list_queries:
            if (len(Queries[q].strip()) > 0):
                qs.append(Queries[q].strip())
        TestQueries.append(qs)
    
    options = ['set enable_result_cache_for_session to off;',
          'set search_path to tpcds_100gb;']

    # start threads
    results = []   
    start_time = time.time()
    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        for ret in executor.map(exec_queries, TestQueries, []):   
            results.append(ret)
    print ("tpch query total time: %d, QPS=%d" % (time.time() - start_time, total * concurrency/(time.time() - start_time))) 
