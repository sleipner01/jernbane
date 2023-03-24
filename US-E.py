import sqlite3

con = sqlite3.connect('jernbanen.db')

# e) En bruker skal kunne registrere seg i kunderegisteret. Denne funksjonaliteten skal programmeres.

"""
Terminal-grensesnitt for å registrere en ny bruker
"""
def registerUser():
    cur = con.cursor()
    fornavn = input("Fornavn: ")
    etternavn = input("Etternavn: ")
    email = input("Email: ")
    tlfNr = input("Telefonnummer (8 siffer): ")
    try:
        cur.execute("INSERT INTO Kunde (fornavn, etternavn, email, tlfNr) VALUES (?, ?, ?, ?)", (fornavn, etternavn, email, tlfNr))
        getNewlyRegisteredUser()
    except:
        print("Noe gikk galt, en bruker må ha unik epost og telefonnummer")
    
    con.commit()
"""
Henter den nyregistrerte brukeren fra databasen
"""
def getNewlyRegisteredUser():
    cur = con.cursor()
    res = cur.execute("SELECT * FROM Kunde WHERE kundenummer = (SELECT MAX(kundenummer) FROM Kunde)").fetchone()
    print("Registrert bruker: " + res[1] + " " + res[2] + " med kundenummer " + str(res[0]))

registerUser()
con.close()