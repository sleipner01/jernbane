import datetime
import sqlite3

con = sqlite3.connect("jernbanen.db")


"""
    Gets all subroutes for a route, checks if there are any tickets for the subroutes, and returns the available seats for the route
    @param travel: the travel to get available seats for as string in format "123456" where the numbers is each station in the route
"""
def getAvailableSeatsOnRoute(travel):

    cur = con.cursor()
    res = cur.execute("""
                        SELECT TF.dato, T.rutenummer, V.vognId, Sitteplass.plassNr as SitteplassNr, Soveplass.plassNr as SoveplassNr,DS.startStasjonId, DS.endeStasjonId,  B2.plassNr, B3.ordrenummer, T.hovedretning, V.vognType FROM Togrute T

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

                        WHERE TF.dato > "2023-04-01 12:00"

                        ORDER BY TF.dato, T.rutenummer, DS.startStasjonId
                    """) 

                    # Idially, the WHERE clause should be: 
                    # WHERE TF.dato > ? and ? = datetime.now()
                    # But due to the fact that the database isnn´t complete with data, we have to use a hardcoded date.
    distances = {}

    """
    Reads SQL response and crates a data structure on format:

    distances = {
        date: {
            route: {
                wagon: {
                    seatNumber: "123456" (available section)
                    ...
                    wagontype: 0/1
                }
                ...
            }
            ...
        }
        ...
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
                distances[d[0]][d[1]][d[2]]["wagontype"] = d[10]
            if(d[7] == None):
                if(d[9] == 0):
                    distances[d[0]][d[1]][d[2]][d[3]] = str(d[5]) + str(d[6]) + distances[d[0]][d[1]][d[2]][d[3]]
                else: 
                    distances[d[0]][d[1]][d[2]][d[3]] += str(d[5]) + str(d[6])
        if(d[4] != None):
            if(d[4] not in distances[d[0]][d[1]][d[2]]):
                distances[d[0]][d[1]][d[2]][d[4]] = ""
                distances[d[0]][d[1]][d[2]]["wagontype"] = d[10] 
            if(d[8] == None):
                if(d[9] == 0):
                    distances[d[0]][d[1]][d[2]][d[4]] = str(d[5]) + str(d[6]) + distances[d[0]][d[1]][d[2]][d[4]]
                else: 
                    distances[d[0]][d[1]][d[2]][d[4]] += str(d[5]) + str(d[6])
            else:
                i = 0
                if (d[4]%2 == 0): i = d[4]-1 
                else: i = d[4]+1
                distances[d[0]][d[1]][d[2]][i] = str(distances[d[0]][d[1]][d[2]][d[4]])[:-1]

    counter = 0
    res = {}

    """

        Find available seats on route on given date.
        If seat is available, add it to res.

        data = {
            date: {
                route: {
                    wagon: {
                        seats: [seat1, seat2, ...]
                        wagontype: 0/1
                    }
                    ...
                }
                ...
            }
            ...
        }

    """
    for date in distances:
        if (date not in res):
            res[date] = {}
        for route in distances[date]:
            if (route not in res[date]):
                res[date][route] = {}
            for wagon in distances[date][route]:
                if (wagon not in res[date][route]):
                    res[date][route][wagon] = {}
                    res[date][route][wagon]["seats"] = []
                for seat in distances[date][route][wagon]:
                    if (seat not in res[date][route][wagon]["seats"]):
                        res[date][route][wagon]["wagontype"] = distances[date][route][wagon]["wagontype"]
                    if(travel in ("".join(dict.fromkeys(str(distances[date][route][wagon][seat]))))):
                        res[date][route][wagon]["seats"].append(str(seat))
                        counter += 1
    
    print("\nTilgejengelige plasser: " + str(counter))

    return res



def printAvailableSeats(data, departure, arrival):

    print("\nLedige plasser fra " + departure + " til " + arrival + ":\n")

    """
        Print available seats on route
    """
    for date in data:
        print("Dato: " + str(date))
        print("---------------------------------------------------------------")
        for route in data[date]:
            stopp = False
            for wagon in data[date][route]:
                if (len(data[date][route][wagon]["seats"]) == 0):
                    stopp = True
            if(not stopp):
                print("\t| Rute:" + str(route))  
                for wagon in data[date][route]:
                    if(data[date][route][wagon]["wagontype"] == 1):
                        print("\t|\n\t| Sovevogn: " + str(wagon))
                        plasstype = "sengeplasser: "
                    else:
                        print("\t|\n\t| Sittevogn: " + str(wagon))
                        plasstype = "seter: "

                    # print("\t|\n\t| Vogn: " + str(wagon))
                    if (len(data[date][route][wagon]["seats"]) > 0):
                        seats = []
                        for seat in data[date][route][wagon]["seats"]:
                            seats.append(str(seat))
                        print("\t| Ledige " + plasstype + ": " + ", ".join(seats) )
                print("---------------------------------------------------------------")


"""
    Get all stations from database for help before user input
"""
def getAllStations():
        
        cur = con.cursor()
        stations = {}
        res = cur.execute("SELECT navn, stasjonId FROM Jernbanestasjon")
        print("|-----------|")
        print("| Stasjoner |")
        print("|-----------|")
        for d in res:
            stations[d[0].lower()] = d[1]
            print("| %9s |" % d[0])
        print("|-----------|")
        return stations


"""
    Get all users from database for help before user input, prints all users in a table
"""
def getUsers():
    cur = con.cursor()
    res = cur.execute("""
        SELECT kundenummer, fornavn, etternavn FROM Kunde
    """)
    res = res.fetchall()

    users = []

    userIds = []

    for user in res:
        userIds.append(user[0])
        tmp = {}
        tmp["kundenummer"] = user[0]
        tmp["fornavn"] = user[1]
        tmp["etternavn"] = user[2]
        users.append(tmp)

    print("\nRegistrerte kunder:\n")
    print("--------------------------------------------------")
    print("Kundenummer:\t| Fornavn: \t| Etternavn:  \t")
    print("--------------------------------------------------")
    for user in users:
        print("| %s \t\t| %s\t\t| %s \t " %(user["kundenummer"], user["fornavn"], user["etternavn"]))
    print("--------------------------------------------------")
    print(" ")
    print("Skriv q for å avslutte programmet\n")

    return userIds

"""
    Creates a new order in database, and returns the order id
"""
def createOrder(customerId):
    cur = con.cursor()
    cur.execute("""
        INSERT INTO Kundeordre (kundeId, tidspunkt) VALUES (?, ?)
        """ , (customerId, "2023-03-24 00:00:00"))
    con.commit()

    orderID = cur.execute("""
        SELECT MAX(ordrenummer) FROM Kundeordre
    """)
    con.commit()

    orderID = orderID.fetchone()[0]

    return orderID

"""
    Insert ticket into database
"""
def buyTicket(orderId, routeNumber, date, wagonId, departureInt, arrivalInt, seatNumber):

    cur = con.cursor()

    try:
        cur.execute("""
            INSERT INTO Billett (ordrenummer, rutenummer, avgangsDato, vognId, startStasjonId, endeStasjonId, plassNr) VALUES (?, ?, ?, ?, ?, ?, ?)
            """ , (orderId, routeNumber, date, wagonId, departureInt, arrivalInt, seatNumber))
        
        con.commit()
        return True
    except:
        print("Kunne ikke kjøpe billett, prøv igjen.")
        return False

"""
    Main function
"""  
def main():

    print("Velkommen til Jernbanesystemet!\n")
    print("Skriv inn q for å avslutte programmet.\n")
    stations = getAllStations()

    res = ""

    getUsers()

    customerId = input("Skriv inn ditt kundenummer: ").strip()

    if(customerId.isdigit()):
        customerId = int(customerId)
    elif(customerId == "q"):
        res = "q"
    else:
        print("Kundenummer må være et tall.")
        res = "q"

    orderId = createOrder(customerId)


    while res != "q":
        res = input("\nSkriv inn en reise for å finne ledige plasser, skriv inn startstasjon og endestasjon sepparert med komma: ").strip()
        if(res == "q"):
            break
        travels = res.split(",")
        if(len(travels) != 2):
            print("Feil input, prøv igjen.")
            continue

        departure = travels[0].strip().lower()
        arrival = travels[1].strip().lower()

        departureInt = stations[departure]
        arrivalInt = stations[arrival]

        travelString = ""
        if(departureInt > arrivalInt):
            for i in range(departureInt, arrivalInt-1, -1):
                travelString += str(i)
        else:
            for i in range(departureInt, arrivalInt+1):
                travelString += str(i)

        availableSeats = getAvailableSeatsOnRoute(travelString)
        printAvailableSeats(availableSeats, departure, arrival)

        res = input("Ønsker du å kjøpe billett? Trykk enter for å fortsette, skriv q for å avslutte: ")

        if(res == "q"):
            break

        while res != "q":
            availableSeats = getAvailableSeatsOnRoute(travelString)

            routeNumber = input("Skriv inn rutenummer for reisen: ").strip()
            if(routeNumber == "q"):
                break
            if(routeNumber.isdigit()):
                routeNumber = int(routeNumber)
            else:
                print("Rutenummer må være et tall.")
                continue


            date = input("Skriv inn dato for reisen på format (yyyy-mm-dd): ").strip()
            if(date == "q"):
                break
            if(len(date) != 10):
                print("Dato må være på formatet (yyyy-mm-dd)")
                continue


            wagonId = input("Skriv inn vognnummer for reisen: ").strip()
            if(wagonId == "q"):
                break
            if(wagonId.isdigit()):
                wagonId = int(wagonId)
            else:
                print("Vognnummer må være et tall.")
                continue


            seatNumber = input("Skriv inn plassnummer for reisen: ").strip()
            if(seatNumber == "q"):
                break
            if(seatNumber.isdigit()):
                seatNumber = int(seatNumber)
            else:
                print("Plassnummer må være et tall.")
                continue

            occupiedSeats = []

            try:
                if(str(seatNumber) in availableSeats[date][routeNumber][wagonId]["seats"]):
                    occupiedSeats.append(seatNumber)
                    validBuy = buyTicket(orderId, routeNumber, date, wagonId, departureInt, arrivalInt, seatNumber)
                    if(validBuy): 
                        print("Billett kjøpt!")

                        while res != "q":
                            res = input("Ønsker du å legge til en ny billett i samme vogn? Trykk enter for å fortsette, skriv q for å avslutte: ")
                            if(res == "q"):
                                break

                            seatNumber = input("Skriv inn plassnummer: ").strip()
                            if(seatNumber == "q"):
                                break
                            if(seatNumber.isdigit()):
                                seatNumber = int(seatNumber)
                            else:
                                print("Plassnummer må være et tall.")
                                continue
                            if(str(seatNumber) in availableSeats[date][routeNumber][wagonId]["seats"] and seatNumber not in occupiedSeats):
                                occupiedSeats.append(seatNumber)
                                buyTicket(orderId, routeNumber, date, wagonId, departureInt, arrivalInt, seatNumber)
                            else:
                                print("Plassen er ikke ledig, prøv igjen.")
                                continue

                else: 
                    print("Plassen er ikke ledig, prøv igjen.")
                    continue
            except:
                print("Kunne ikke kjøpe billett, prøv igjen.")
                continue

            res = input("Ønsker du å kjøpe ny billett? Trykk enter for å fortsette, skriv q for å avslutte: ")

    print("programmet avsluttes")

main()

con.close()