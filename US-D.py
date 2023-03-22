import sqlite3

con = sqlite3.connect("jernbanen.db")


"""

Henter ut alle stasjonene fra databasen og returnerer en dict med navn som key og stasjonId som value.

"""
def getStations():
    queryRes = con.cursor().execute("SELECT navn, stasjonId FROM Jernbanestasjon").fetchall()
    
    map = {}
    for station in queryRes:
        map[station[0]] = station[1]

    stations = []
    for station in queryRes:
        stations.append(station[0])


    return map, stations




"""

Printer ut alle stasjonene i en fin tabell.

@params stations: en liste med stasjonsnavn

"""
def printStations(stations):
    print("Eksisterende stasjoner:\n")
    print("|-----------|")
    print("| Navn      |")
    print("|-----------|")
    for station in stations:
        print("| %9s |" % (station))
    print("|-----------|\n")





"""

Henter ut alle ruter som går på en gitt dato etter gitt klokkeslett og påfølgende dato.

"""
def getRoutesData(date, time, nextdate):
    cur = con.cursor()
    res = cur.execute("""
                SELECT TF.dato, S.rutenummer, S.stoppNummer, S.stasjonId FROM Togrute T
                    JOIN Stoppested S ON S.rutenummer = T.rutenummer
                    JOIN Togruteforekomst TF ON TF.rutenummer = T.rutenummer
                    JOIN Stoppested avreise ON (avreise.rutenummer = T.rutenummer AND avreise.stoppNummer = 1)
                    WHERE (dato = ? AND avreise.avgangsTid > ?)OR dato= ?
                    ORDER BY dato, avreise.avgangsTid, S.rutenummer, S.stoppnummer ASC
                """, (date, time, nextdate))
    return res.fetchall()




"""

    Strukturerer dataen slik at vi får en dict med datoer som keys, og rutenummer som keys i disse dictene. 
    Dette gjør det enklere å finne ruter som går mellom to stasjoner.
    {
        "2023-04-03": {
            "1": "123456",
            "2": "123456",
            "3": "4321"
        },
        "2023-04-04": {
            "1": "123456",
            "2": "123445",
            "3": "4321"
        }

    @param routeData: Dataen som skal struktureres
    @return: Strukturert data på formen som er beskrevet over

"""
def routeDataToDict(routeData):
    routes = {}
    for route in routeData:
        if route[0] not in routes:
            routes[route[0]] = {}
            routes[route[0]][route[1]] = str(route[3])
        else:
            if route[1] not in routes[route[0]]:
                routes[route[0]][route[1]] = str(route[3])
            else:
                routes[route[0]][route[1]] += str(route[3])
    return routes




"""

    Henter ut alle ruter som går fra startstasjon til sluttstasjon.
    @param routes: Alle ruter i et dict
    @param fromStationId: Avreisestasjon
    @param toStationId: Endestasjon

"""
def getExistingRoutes(routes, fromStationId, toStationId):
    existingRoutes = []
    for date in routes:
        for route in routes[date]:
            if str(fromStationId) in routes[date][route] and str(toStationId) in routes[date][route]:
                if routes[date][route].index(str(fromStationId)) < routes[date][route].index(str(toStationId)):
                    existingRoutes.append([date, str(route)])
    return existingRoutes




"""

    Henter ut data om en bestemt rute og printer den ut.

    @param date: Datoen ruten går
    @param route: Rutenummeret
    @param fromStationId: Avreisestasjon
    @param toStationId: Endestasjon

"""
def getRouteData(date, route, fromStationId, toStationId):
    cur = con.cursor()
    res = cur.execute("""
                SELECT Togrute.rutenummer, j1.navn, s.avgangstid, j2.navn, e.ankomstTid FROM Togrute 
                    JOIN Togruteforekomst ON Togruteforekomst.rutenummer = Togrute.rutenummer
                    JOIN Stoppested s ON s.stasjonId = ? AND s.rutenummer = Togrute.rutenummer
                    JOIN Stoppested e ON e.stasjonId = ? AND e.rutenummer = Togrute.rutenummer
                    JOIN Jernbanestasjon j1 ON s.StasjonId = j1.stasjonId
                    JOIN Jernbanestasjon j2 ON e.StasjonId = j2.stasjonId
                    WHERE Togruteforekomst.dato = ? AND Togrute.rutenummer = ?
                """,(fromStationId, toStationId, date, route))
    for row in res:

        print("""
    -------------------------
    Dato: %s
    Rute: %s
    Fra: %10s kl. %5s
    Til: %10s kl. %5s
    -------------------------
        """ % (date, row[0], row[1], row[2], row[3], row[4]))



"""

    Henter ut neste dato.

    @Param date: Datoen som skal brukes som utgangspunkt for neste dato på formen "yyyy-mm-dd"

"""
def getNextDate(date):
    dates = date.split("-")
    year = int(dates[0])
    month = int(dates[1])
    day = int(dates[2])

    if day == 30:
        day = 1
        if month == 12:
            month = 1
            year += 1
        else:
            month += 1
    else:
        day += 1

    if(month < 10):
        month = "0" + str(month)
    if(day < 10):
        day = "0" + str(day)

    return str(year) + "-" + str(month) + "-" + str(day)



def main():
    print("Velkommen til Jernbanen, her kan du se hvilke ruter som går fra og til en stasjon med utgangspunkt i dato")
    print("Tast inn q for å avslutte programmet\n")
    stationsMap, stations = getStations()
    printStations(stations)

    res = ""

    while res != "q":
        res = input("Velg to stasjoner fra listen over stasjoner separert med komma uten mellomrom (f.eks. Trondheim,Bodø): ").strip()
        if res == "q":
            break
        res = res.split(",")
        if len(res) != 2:
            print("Ugyldig input, prøv igjen")
            continue

        fromStation = res[0].strip()
        toStation = res[1].strip()

        if fromStation not in stations or toStation not in stations:
            print("Ugyldige stasjoner, velg stasjoner fra listen")
            continue

        fromStationId = stationsMap[fromStation]
        toStationId = stationsMap[toStation]

        res = input("Velg dato på formatet YYYY-MM-DD: ").strip()
        if res == "q":
            break
        dates = res.split("-")
        if len(dates) != 3:
            print("Ugyldig dato, prøv igjen")
            continue
        if(len(dates[0]) != 4 or len(dates[1]) != 2 or len(dates[2]) != 2):
            print("Ugyldig dato, prøv igjen")
            continue
        try:
            int(dates[0])
            int(dates[1])
            int(dates[2])
        except:
            print("Ugyldig dato, prøv igjen")
            continue
        date = dates[0] + "-" + dates[1] + "-" + dates[2]
        nextDate = getNextDate(date)

        res = input("Velg tidspunkt på formatet HH:MM: ")
        if res == "q":
            break
        times = res.strip().split(":")
        if len(times) != 2:
            print("Ugyldig tidspunkt, prøv igjen")
            continue
        if(len(times[0]) != 2 or len(times[1]) != 2):
            print("Ugyldig tidspunkt, prøv igjen")
            continue
        try:
            numHours = int(times[0])
            numMinutes = int(times[1])
        except:
            print("Ugyldig tidspunkt, prøv igjen")
            continue
        if numHours < 0 or numHours > 23 or numMinutes < 0 or numMinutes > 59:
            print("Ugyldig tidspunkt, prøv igjen")
            continue
        time = times[0] + ":" + times[1]

        routesData = getRoutesData(date, time, nextDate)
        routes = routeDataToDict(routesData)
        existingRoutes = getExistingRoutes(routes, fromStationId, toStationId)
        for route in existingRoutes:
            getRouteData(route[0], route[1], fromStationId, toStationId)

main()
con.close()