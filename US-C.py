import sqlite3

con = sqlite3.connect('jernbanen.db')

def getStations():
    stations = con.cursor().execute("SELECT navn FROM Jernbanestasjon").fetchall()
    res = []
    for station in stations:
        res.append(station[0])
    return res


def getTrainsPerDayPerStation(date, station):
    routeInfo = []
    
    cur = con.cursor()
    res = cur.execute("""
                SELECT Togrute.rutenummer, Stoppested.avgangsTid FROM Jernbanestasjon 
                    JOIN Stoppested ON Stoppested.stasjonId = Jernbanestasjon.stasjonId
                    JOIN Togrute ON Stoppested.rutenummer = Togrute.rutenummer
                    JOIN Togruteforekomst ON Togruteforekomst.rutenummer = Togrute.rutenummer
                    WHERE Jernbanestasjon.navn = ? AND Togruteforekomst.dato = ?
                """, (station, date))
    
    routes = res.fetchall()
    for route in routes:
        cur = con.cursor()
        res = cur.execute("""
                    SELECT Jernbanestasjon.navn FROM Stoppested
                    JOIN Jernbanestasjon ON Stoppested.stasjonId = Jernbanestasjon.stasjonId
                    WHERE Stoppested.rutenummer = ?
                    ORDER BY stoppNummer
                    """, ((route[0],)))
        stops = res.fetchall()
        routeInfo.append("Rute " + str(route[0]) + ": " + ", ".join(stops[0]) + " - " + " - ".join(stops[-1]) + " (" + ("Avgang: " + route[1] if route[1] else "Endestasjon") + ")" )

    return routeInfo


def printResult(res, date, station):
    values = []
    for value in res:
        values.append(value)

    print("\nRuter som går innom " + station + " den " + date + ":")

    if (len(values) == 0):
        print("Ingen ruter denne dagen")
        return

    for value in values:
        print(value)


def dayToDate(day):
    dayConverter = {
        "man": "2023-04-03",
        "tir": "2023-04-04",
        "ons": "2023-04-05",
        "tor": "2023-04-06",
        "fre": "2023-04-07",
        "lør": "2023-04-08",
        "søn": "2023-04-09"
    }
    return dayConverter.get(day, "undefined")


def main():
    stations = getStations()

    print("Velkommen til Jernbanen, her kan du se hvilke ruter som går fra en stasjon på en gitt ukedag\n")
    print("Dag på format (man, tir, ons, tor, fre, lør, søn))\n")
    print("Stasjoner: ")
    print(", ".join(stations))
    print("\n(Skriv q for å avslutte)")

    res = ""

    while res != "q":
        res = input(
            "Skriv inn ukedag og stasjon separert med komma (,) uten mellomrom: ")

        if (len(res.split(",")) != 2):
            print("Du må skrive inn dato og stasjon")
            continue

        day = res.split(",")[0].strip()
        station = res.split(",")[1].strip()

        date = dayToDate(day) # converts day to date since we only have dates in the database and every week is equal

        if (date == "undefined"):
            print("Ugyldig dag")
            continue

        if (station not in stations):
            print("Stasjonen finnes ikke")
            continue

        printResult(getTrainsPerDayPerStation(date, station), date, station)

        res = "q"


main()
con.close()
