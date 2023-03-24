import sqlite3

con = sqlite3.connect("jernbanen.db")

## Denne funker!
#  SELECT TF.dato, T.rutenummer, DS.startStasjonId, DS.endeStasjonId, V.vognId as "VognID", SitteVogn.vognId as "Sittevogn ID",  B.vognId as "Billett vognID", B.ordrenummer, Sitteplass.plassNr, Soveplass.plassNr, B2.plassNr, B3.plassNr FROM Togrute T
# -- SELECT * FROM Togrute T
# JOIN TogruteHarDelstrekning DS ON T.rutenummer = DS.rutenummer
# JOIN Togruteforekomst TF ON TF.rutenummer = T.rutenummer
# JOIN Billett B ON (B.avgangsDato = TF.dato AND T.rutenummer = B.rutenummer)
# JOIN VognOppsett VO ON VO.vognOppsettId = T.vognOppsettId
# JOIN VognerPaaVognOppsett VPVO ON VPVO.vognOppsettId = VO.vognOppsettId AND T.vognOppsettId = VO.vognOppsettId
# JOIN Vogn V ON V.vognId = VPVO.vognId
# LEFT  JOIN SitteVogn ON SitteVogn.vognId = V.vognId
# LEFT JOIN SoveVogn ON SoveVogn.vognId = V.vognId
# LEFT JOIN Plass Sitteplass ON Sitteplass.vognId = SitteVogn.vognId 
# LEFT JOIN Plass Soveplass ON Soveplass.vognId = SoveVogn.vognId
# LEFT JOIN Billett B2 ON B2.plassNr = Sitteplass.plassNr AND B2.vognId = Sitteplass.vognId
# LEFT JOIN Billett B3 ON B3.plassNr = Soveplass.plassNr AND B3.vognId = Soveplass.vognId


# WHERE T.rutenummer = 2 AND TF.dato = "2023-04-04"

# ORDER BY TF.dato, T.rutenummer, DS.startStasjonId

def getAvailableSeatsOnRoute(route):

    cur = con.cursor()
    res = cur.execute("""
                        SELECT TF.dato, T.rutenummer, V.vognId as "VognID", Sitteplass.plassNr as SitteplassNr, Soveplass.plassNr as SoveplassNr,DS.startStasjonId, DS.endeStasjonId,  B2.plassNr, B3.ordrenummer, T.hovedretning FROM Togrute T

                        JOIN TogruteHarDelstrekning DS ON T.rutenummer = DS.rutenummer
                        JOIN Togruteforekomst TF ON TF.rutenummer = T.rutenummer
                        JOIN VognOppsett VO ON VO.vognOppsettId = T.vognOppsettId
                        JOIN VognerPaaVognOppsett VPVO ON VPVO.vognOppsettId = VO.vognOppsettId AND T.vognOppsettId = VO.vognOppsettId
                        JOIN Vogn V ON V.vognId = VPVO.vognId
                        LEFT  JOIN SitteVogn ON SitteVogn.vognId = V.vognId
                        LEFT JOIN SoveVogn ON SoveVogn.vognId = V.vognId
                        LEFT JOIN Plass Sitteplass ON Sitteplass.vognId = SitteVogn.vognId 
                        LEFT JOIN Plass Soveplass ON Soveplass.vognId = SoveVogn.vognId
                        LEFT JOIN Billett B2 ON B2.plassNr = Sitteplass.plassNr AND B2.vognId = Sitteplass.vognId AND TF.dato = B2.avgangsDato AND TF.rutenummer = B2.rutenummer AND  ((DS.startStasjonId >= B2.startStasjonId AND DS.endeStasjonId <= B2.endeStasjonId) OR (DS.startStasjonId <= B2.startStasjonId AND DS.endeStasjonId >= B2.endeStasjonId))
                        LEFT JOIN Billett B3 ON B3.plassNr = Soveplass.plassNr AND B3.vognId = Soveplass.vognId AND TF.dato = B3.avgangsDato AND TF.rutenummer = B3.rutenummer AND  ((DS.startStasjonId >= B3.startStasjonId AND DS.endeStasjonId <= B3.endeStasjonId) OR (DS.startStasjonId <= B2.startStasjonId AND DS.endeStasjonId >= B2.endeStasjonId))


                        -- WHERE T.rutenummer = ? AND TF.dato = "2023-04-04"

                        ORDER BY TF.dato, T.rutenummer, DS.startStasjonId
                    """)
    # , (str(route)))
    
    distances = {}

    """
    Data structure:

        Date:
            Route:
                Wagon:
                    Seat: "Stations not booked"


    {
        "2023-04-04": {
            "2": {
                "3": {
                    "1": "123456",
                    "2": "123456",
                    "3": "123",
                    "4": ""
                    },
                "4": {
                    "1": "123456",  
                    "2": "123456",
                    "3": "123",
                    "4": ""
                    }
                }
            }
        }
    """
    
    for d in res:
        if(d[0] not in distances):
            distances[d[0]] = {}
        if(d[1] not in distances[d[0]]):
            distances[d[0]][d[1]] = {}
        if(d[2] not in distances[d[0]][d[1]]):
            distances[d[0]][d[1]][d[2]] = {}
        if(d[3] != None):
            if(d[3] not in distances[d[0]][d[1]][d[2]]):
                distances[d[0]][d[1]][d[2]][d[3]] = ""
            if(d[7] == None):
                if(d[9] == 0):
                    distances[d[0]][d[1]][d[2]][d[3]] = str(d[6]) + str(d[5]) + distances[d[0]][d[1]][d[2]][d[3]]
                else: 
                    distances[d[0]][d[1]][d[2]][d[3]] += str(d[5]) + str(d[6])
        if(d[4] != None):
            if(d[4] not in distances[d[0]][d[1]][d[2]]):
                distances[d[0]][d[1]][d[2]][d[4]] = ""
            if(d[8] == None):
                if(d[9] == 0):
                    distances[d[0]][d[1]][d[2]][d[4]] = str(d[6]) + str(d[5]) + distances[d[0]][d[1]][d[2]][d[4]]
                else: 
                    distances[d[0]][d[1]][d[2]][d[4]] += str(d[5]) + str(d[6])
            # else:
            #     i = 0
            #     if (d[4]%2 == 0): i = d[4]-1 
            #     else: i = d[4]+1
            #     print(distances[d[0]][d[1]][d[2]][d[i]])
            #     distances[d[0]][d[1]][d[2]][i] = str(distances[d[0]][d[1]][d[2]][d[4]])[:-1]

    counter = 0
    """
        print distances in a nice way

    """
    for date in distances:
        print ("Date: " + date)
        for route in distances[date]:
            print ("\tRoute: " + str(route))
            for wagon in distances[date][route]:
                print ("\t\tWagon: " + str(wagon))
                for seat in distances[date][route][wagon]:
                    if(len(str(distances[date][route][wagon][seat])) == 0):
                        counter += 1
                    print ("\t\t\tSeat: %2s %s " %((str(seat) , str(distances[date][route][wagon][seat]))))

    fromStationId = 1
    toStationId = 6

    # print("\n\nAvailable seats from station: " + str(fromStationId) + " to station: " + str(toStationId) + "\n")
    # for date in distances:
    #     for route in distances[date]:
    #         for wagon in distances[date][route]:
    #             for seat in distances[date][route][wagon]:
    #                 try:
    #                     if distances[date][route][wagon][seat].index(str(fromStationId)) < distances[date][route][wagon][seat].index(str(toStationId)):
    #                         print("Seat: " + str(seat) + " is available on route: " + str(route) + " on date: " + str(date) + " on wagon: " + str(wagon))
    #                 except:
    #                     pass
    print("\nTotalt antall kjøpte billetter: " + str(counter))


getAvailableSeatsOnRoute(2)