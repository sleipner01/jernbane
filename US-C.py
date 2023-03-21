import sqlite3;

con = sqlite3.connect('jernbanen.db')

def getTrainsPerDayPerStation(date, station):
    cur = con.cursor()
    res = cur.execute("""
                SELECT * FROM Jernbanestasjon 
                JOIN Stoppested ON Stoppested.stasjonId = Jernbanestasjon.stasjonId
                JOIN Togrute ON Stoppested.rutenummer = Togrute.rutenummer
                JOIN Togruteforekomst ON Togruteforekomst.rutenummer = Togrute.rutenummer
                WHERE Jernbanestasjon.navn = ? AND Togruteforekomst.dato = ?
                """, (date, station))
    return res.fetchone()


print(getTrainsPerDayPerStation("Trondheim", "2023-03-21"))