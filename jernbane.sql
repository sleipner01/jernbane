-- SQL

CREATE TABLE Banestrekning (
    banestrekningID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(255) NOT NULL
);

CREATE TABLE Jernbanestasjon (
    stasjonID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(255) NOT NULL,
    moh INTEGER NOT NULL
);

CREATE TABLE Delstrekning (
    startStasjonID INTEGER NOT NULL,
    endeStasjonID INTEGER NOT NULL,
    avstand INTEGER NOT NULL,
    sportype BOOLEAN NOT NULL,
    FOREIGN KEY (startStasjonID) REFERENCES Jernbanestasjon(stasjonID),
    FOREIGN KEY (endeStasjonID) REFERENCES Jernbanestasjon(stasjonID)
);

CREATE TABLE DelstrekningPaaBanestrekning (
    banestrekningID INTEGER NOT NULL,
    startStasjonID INTEGER NOT NULL,
    endeStasjonID INTEGER NOT NULL,
    FOREIGN KEY (banestrekningID) REFERENCES Banestrekning(banestrekningID),
    FOREIGN KEY (startStasjonID) REFERENCES Delstrekning(startStasjonID),
    FOREIGN KEY (endeStasjonID) REFERENCES Delstrekning(endeStasjonID)
);

CREATE TABLE Togrute (
    togruteID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    operatorID INTEGER NOT NULL,
    vognOppsettID INTEGER NOT NULL,
    hovedretning BOOLEAN NOT NULL,
    FOREIGN KEY (operatorID) REFERENCES Operator(operatorID),
    FOREIGN KEY (vognOppsettID) REFERENCES Operator(vognOppsettID)
);

CREATE TABLE Stoppested (
    togruteID INTEGER NOT NULL,
    stasjonID INTEGER NOT NULL,
    stoppNummer INTEGER NOT NULL,
    ankomstKlokkeslett TIME,
    avgangKlokkeslett TIME,
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID),
    FOREIGN KEY (stasjonID) REFERENCES Jernbanestasjon(stasjonID)
);

CREATE TABLE Togruteforekomst (
    togruteID INTEGER NOT NULL,
    dato DATE NOT NULL,
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID)
);

CREATE TABLE Operator (
    operatorID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(255) NOT NULL
);

CREATE TABLE Vogn (
    vognID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(255) NOT NULL,
    operatorID INTEGER NOT NULL,
    vognType INTEGER NOT NULL,
    FOREIGN KEY (operatorID) REFERENCES Operator(operatorID)
);

CREATE TABLE SoveVogn (
    vognID INTEGER NOT NULL,
    antallKupeer INTEGER NOT NULL,
    antallSengerPerKupe INTEGER NOT NULL,
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID)
);

CREATE TABLE SeteVogn (
    vognID INTEGER NOT NULL,
    antallRader INTEGER NOT NULL,
    antallSeterPerRad INTEGER NOT NULL,
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID)
);

CREATE TABLE VognOppsett (
    vognOppsettID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    beskrivelse varchar(255)
);

CREATE TABLE VognerPaaVognOppsett (
    vognOppsettID INTEGER NOT NULL,
    vognID INTEGER NOT NULL,
    rekkefolge INTEGER NOT NULL, 
    FOREIGN KEY (vognOppsettID) REFERENCES VognOppsett(vognOppsettID),
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID)
);

CREATE TABLE Kunde (
    kundeID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    firstName varchar(255) NOT NULL,
    lastName varchar(255) NOT NULL,
    tlfNr varchar(255) NOT NULL,
    email varchar(255) NOT NULL
);

CREATE TABLE Kundeordre (
    ordrenummer INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    kundeID INTEGER NOT NULL,
    tidspunkt datetime NOT NULL,
    FOREIGN KEY (kundeID) REFERENCES Kunde(kundeID)
);

CREATE TABLE Billett (
    billettID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    ordrenummer INTEGER NOT NULL,
    togruteID INTEGER NOT NULL,
    avgangsDato DATE NOT NULL,
    vognID INTEGER NOT NULL,
    radNr INTEGER NOT NULL,
    seteNr INTEGER NOT NULL,
    FOREIGN KEY (ordrenummer) REFERENCES Kundeordre(ordrenummer),
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID),
    FOREIGN KEY (avgangsDato) REFERENCES Togruteforekomst(dato),
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID)
);