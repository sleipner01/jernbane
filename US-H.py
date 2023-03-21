import sqlite3
import datetime

con = sqlite3.connect('jernbanen.db')

def getTickets(kundeNummer):
    cur = con.cursor()
    res = cur.execute("""
                SELECT kundenummer, fornavn, etternavn, tidspunkt as "Kjøpetidspunkt", B.rutenummer, 
                avgangsDato, rekkefolge as "Vogn-rekkefolge", plassNr, j.navn, j2.navn, S1.avgangsTid, S2.ankomstTid
                FROM Kunde K

                JOIN Kundeordre KO ON K.kundenummer = KO.ordrenummer
                JOIN Billett B ON B.ordrenummer = KO.ordrenummer
                JOIN Jernbanestasjon j ON B.startStasjonId = j.stasjonId 
                JOIN Jernbanestasjon j2  ON B.endeStasjonId = j2.stasjonId
                JOIN Stoppested s1 ON B.startStasjonId = s1.stasjonId AND s1.rutenummer = B.rutenummer
                JOIN Stoppested s2 ON B.endeStasjonId = s2.stasjonId AND s2.rutenummer = B.rutenummer

                JOIN (  Togrute t2
                    JOIN VognOppsett ON VognOppsett.vognOppsettId = t2.vognOppsettId
                    JOIN VognerPaaVognOppsett ON VognerPaaVognOppsett.vognOppsettId = VognOppsett.vognOppsettId
                    JOIN Vogn ON VognerPaaVognOppsett.vognId = Vogn.vognId) ON t2.rutenummer = Vogn.vognId = B.vognId

                    WHERE K.kundenummer = ? AND avgangsDato > ?
                """, (str(kundeNummer) , str(datetime.datetime.now())))
    
    return res.fetchall()

def dataToDict(data):
    dict = []
    for row in data:
        tmp = {}
        tmp["kundenummer"] = row[0]
        tmp["fornavn"] = row[1]
        tmp["etternavn"] = row[2]
        tmp["kjøpetidspunkt"] = row[3]
        tmp["rutenummer"] = row[4]
        tmp["avgangsDato"] = row[5]
        tmp["Vogn-rekkefølge"] = row[6]
        tmp["plassNr"] = row[7]
        tmp["startStasjon"] = row[8]
        tmp["sluttStasjon"] = row[9]
        tmp["avreise"] = row[10]
        tmp["ankomst"] = row[11]
        dict.append(tmp)

    return dict

def printData(dict):
    if len(dict) == 0:
        print("Ingen reiser funnet for kunde\n")
        return

    print("\nKommende reiser for kunde: ", dict[0]["kundenummer"])
    for ticket in dict:
        print("""
            \rDato: %s 
            \r---------------------------------
            \rFra: %9s     Til: %9s
            \rAvgang: %5s      Ankomst: %5s
            \rRutenummer: %s
            \r---------------------------------
            \rVogn-rekkefølge: %3s  PlassNr: %2s
            
        """ %(ticket["avgangsDato"], ticket["startStasjon"], ticket["sluttStasjon"], ticket["avreise"], ticket["ankomst"], ticket["rutenummer"], ticket["Vogn-rekkefølge"], ticket["plassNr"]))
        
def getUsers():
    cur = con.cursor()
    res = cur.execute("""
        SELECT kundenummer, fornavn, etternavn FROM Kunde
    """)
    res = res.fetchall()

    users = []
    for user in res:
        tmp = {}
        tmp["kundenummer"] = user[0]
        tmp["fornavn"] = user[1]
        tmp["etternavn"] = user[2]
        users.append(tmp)

    print("Registrerte kunder:\n")
    print("Kundenummer\t| Fornavn \t| Etternavn")
    print("--------------------------------------------------")
    for user in users:
        print("%s \t\t| %s\t\t| %s" %(user["kundenummer"], user["fornavn"], user["etternavn"]))
    print("--------------------------------------------------")
    print(" ")
    print("Skriv q for å avslutte programmet\n")

def main():

    getUsers()
    res = ""
    while res != "q":
        res = input("Skriv inn ditt kundenummer for å se dine fremtidige reiser: ")
        if res == "q":
            break
        else:
            data = getTickets(res)
            dict = dataToDict(data)
            printData(dict)
            break


main()