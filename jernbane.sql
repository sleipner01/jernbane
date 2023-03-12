-- SQL

CREATE TABLE Banestrekning (
    banestrekningId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(255) NOT NULL,
    fremdriftsenergi varchar(255) NOT NULL,
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    FOREIGN KEY (startStasjonId) REFERENCES Jernbanestasjon(stasjonId),
    FOREIGN KEY (endeStasjonId) REFERENCES Jernbanestasjon(stasjonId)
);

CREATE TABLE Jernbanestasjon (
    stasjonId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(255) NOT NULL,
    moh INTEGER NOT NULL
);

CREATE TABLE Delstrekning (
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    avstand INTEGER NOT NULL,
    sportype BOOLEAN NOT NULL,
    FOREIGN KEY (startStasjonId) REFERENCES Jernbanestasjon(stasjonId),
    FOREIGN KEY (endeStasjonId) REFERENCES Jernbanestasjon(stasjonId)
);

CREATE TABLE DelstrekningPaaBanestrekning (
    banestrekningId INTEGER NOT NULL,
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    FOREIGN KEY (banestrekningId) REFERENCES Banestrekning(banestrekningId),
    FOREIGN KEY (startStasjonId) REFERENCES Delstrekning(startStasjonId),
    FOREIGN KEY (endeStasjonId) REFERENCES Delstrekning(endeStasjonId)
);

CREATE TABLE Togrute (
    rutenummer INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    operatorId INTEGER NOT NULL,
    vognOppsettId INTEGER NOT NULL,
    banestrekningId INTEGER NOT NULL,
    hovedretning BOOLEAN NOT NULL,
    FOREIGN KEY (operatorId) REFERENCES Operator(operatorId),
    FOREIGN KEY (vognOppsettId) REFERENCES Operator(vognOppsettId),
    FOREIGN KEY (banestrekningId) REFERENCES Banestrekning(banestrekningId)
);

CREATE TABLE TogruteHarDelstrekning (
    rutenummer INTEGER NOT NULL,
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    FOREIGN KEY (rutenummer) REFERENCES Togrute(rutenummer),
    FOREIGN KEY (startStasjonId) REFERENCES Delstrekning(stasjonId),
    FOREIGN KEY (endeStasjonId) REFERENCES Delstrekning(stasjonId)
);

CREATE TABLE Stoppested (
    rutenummer INTEGER NOT NULL,
    stasjonId INTEGER NOT NULL,
    stoppNummer INTEGER NOT NULL,
    ankomstTid TIME,
    avgangsTid TIME,
    FOREIGN KEY (rutenummer) REFERENCES Togrute(rutenummer),
    FOREIGN KEY (stasjonId) REFERENCES Jernbanestasjon(stasjonId)
);

CREATE TABLE Togruteforekomst (
    togruteId INTEGER NOT NULL,
    dato DATE NOT NULL,
    FOREIGN KEY (togruteId) REFERENCES Togrute(togruteId)
);

CREATE TABLE Operator (
    operatorId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(255) NOT NULL
);

CREATE TABLE Vogn (
    vognId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    operatorId INTEGER NOT NULL,
    vognType INTEGER NOT NULL,
    FOREIGN KEY (operatorId) REFERENCES Operator(operatorId)
);

CREATE TABLE SitteVogn (
    vognId INTEGER NOT NULL,
    antallRader INTEGER NOT NULL,
    antallSeterPerRad INTEGER NOT NULL,
    FOREIGN KEY (vognId) REFERENCES Vogn(vognId)
);

CREATE TABLE SoveVogn (
    vognId INTEGER NOT NULL,
    antallKupeer INTEGER NOT NULL,
    antallSengerPerKupe INTEGER NOT NULL,
    FOREIGN KEY (vognId) REFERENCES Vogn(vognId)
);

CREATE TABLE VognOppsett (
    vognOppsettId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    beskrivelse varchar(255)
);

CREATE TABLE VognerPaaVognOppsett (
    vognOppsettId INTEGER NOT NULL,
    vognId INTEGER NOT NULL,
    rekkefolge INTEGER NOT NULL, 
    FOREIGN KEY (vognOppsettId) REFERENCES VognOppsett(vognOppsettId),
    FOREIGN KEY (vognId) REFERENCES Vogn(vognId)
);

CREATE TABLE Kunde (
    kundenummer INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    fornavn varchar(255) NOT NULL,
    etternavn varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    tlfNr varchar(255) NOT NULL
);

CREATE TABLE Kundeordre (
    ordrenummer INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    kundeId INTEGER NOT NULL,
    tidspunkt datetime NOT NULL,
    FOREIGN KEY (kundeId) REFERENCES Kunde(kundeId)
);

CREATE TABLE Billett (
    ordrenummer INTEGER NOT NULL,
    rutenummer INTEGER NOT NULL,
    avgangsDato DATE NOT NULL,
    vognId INTEGER NOT NULL,
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    plassNr INTEGER NOT NULL,
    FOREIGN KEY (ordrenummer) REFERENCES Kundeordre(ordrenummer),
    FOREIGN KEY (rutenummer) REFERENCES Togrute(rutenummer),
    FOREIGN KEY (avgangsDato) REFERENCES Togruteforekomst(dato),
    FOREIGN KEY (vognId) REFERENCES Vogn(vognId),
    FOREIGN KEY (startStasjonId) REFERENCES Jernbanestasjon(stasjonId),
    FOREIGN KEY (endeStasjonId) REFERENCES Jernbanestasjon(stasjonId)
);