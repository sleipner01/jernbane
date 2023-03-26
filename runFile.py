import sqlite3


"""
Kjører sql-scriptet i filen som blir gitt som parameter.
Skriptet kjøres opp mot jernbanen.db databasen.

@:param filename: navnet på filen som inneholder sql-scriptet
"""
def runFile(filename):
    with open(filename, 'r') as sql_file:
        sql_script = sql_file.read()

    db = sqlite3.connect('jernbanen.db')
    cursor = db.cursor()
    cursor.executescript(sql_script)
    db.commit()
    db.close()

runFile("dropTables.sql") # for å slette databasen
runFile('jernbane.sql') # for å lage databasen
runFile('eksempelData.sql') # for å legge inn eksempeldata

