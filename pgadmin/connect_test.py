import psycopg2
dbname = ""
user = ""
password = ""
host = ""
print(psycopg2.connect(f"dbname={dbname} user={user} host={host} password={password} port=5432"))
