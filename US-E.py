import sqlite3

con = sqlite3.connect('jernbanen.db')

# e) En bruker skal kunne registrere seg i kunderegisteret. Denne funksjonaliteten skal programmeres.

def registerUser():
    cur = con.cursor()
    fornavn = input("Navn: ")
    etternavn = input("Etternavn: ")
    email = input("Email: ")
    tlfNr = input("Telefonnummer: ")
    cur.execute("INSERT INTO Kunde (fornavn, etternavn, email, tlfNr) VALUES (?, ?, ?, ?)", (fornavn, etternavn, email, tlfNr))
    con.commit()

registerUser()