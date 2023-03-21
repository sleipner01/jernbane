import sqlite3

def runFile(filename):
    with open(filename, 'r') as sql_file:
        sql_script = sql_file.read()

    db = sqlite3.connect('jernbanen.db')
    cursor = db.cursor()
    cursor.executescript(sql_script)
    db.commit()
    db.close()


# runFile('jernbane.sql') for å lage databasen
runFile('eksempelData.sql')

