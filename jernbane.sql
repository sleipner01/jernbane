-- SQL

CREATE TABLE Banestrekning (
    banestrekningID int,
    navn varchar(255),
    PRIMARY KEY (banestrekningID),
    AUTO_INCREMENT (banestrekningID),
    NOT NULL (banestrekningID, navn)
);

CREATE TABLE Jernbanestasjon (
    stasjonID int,
    navn varchar(255),
    moh int,
    PRIMARY KEY (stasjonID),
    AUTO_INCREMENT (stasjonID),
    NOT NULL (stasjonID, navn)
);

CREATE TABLE Delstrekning (
    startStasjonID int,
    endeStasjonID int,
    avstand int,
    sportype BOOLEAN, --0 for enkeltspor, 1 for dobbeltspor 
    FOREIGN KEY (stasjonID) REFERENCES Jernbanestasjon(stasjonID)
    AUTO_INCREMENT (delstrekningID),
    NOT NULL (startStasjonID, endeStasjonID),
);

CREATE TABLE DelstrekningPaaBanestrekning (
    banestrekningID int,
    startStasjonID int,
    endeStasjonID int,
    FOREIGN KEY (banestrekningID) REFERENCES Banestrekning(banestrekningID),
    FOREIGN KEY (startStasjonID) REFERENCES Delstrekning(startStasjonID),
    FOREIGN KEY (endeStasjonID) REFERENCES Delstrekning(endeStasjonID),
    AUTO_INCREMENT (delstrekningPaaBanestrekningID),
    NOT NULL (banestrekningID, delstrekningID)
);

CREATE TABLE Togrute (
    togruteID int,
    operatorID int,
    vognOppsettID int,
    hovedretning BOOLEAN, --0 for mot hovedretning, 1 for hovedretning
    FOREIGN KEY (operatorID) REFERENCES Operator(operatorID),
    FOREIGN KEY (vognOppsettID) REFERENCES Operator(vognOppsettID),
    AUTO_INCREMENT (togruteID),
    NOT NULL (togruteID, startStasjonID, endeStasjonID)
);

CREATE TABLE Stoppested (
    togruteID int,
    stasjonID int,
    stoppNummer int,
    ankomstKlokkeslett TIME,
    avgangKlokkeslett TIME,
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID),
    FOREIGN KEY (stasjonID) REFERENCES Jernbanestasjon(stasjonID),
    AUTO_INCREMENT (stoppestedID),
    NOT NULL (togruteID, stasjonID)
);

CREATE TABLE Togruteforekomst (
    togruteID int,
    dato DATE,
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID),
    NOT NULL (togruteID, dato)
);

CREATE TABLE Operator (
    operatorID int,
    navn varchar(255),
    PRIMARY KEY (operatorID),
    AUTO_INCREMENT (operatorID),
    NOT NULL (operatorID, navn)
);

CREATE TABLE Vogn (
    vognID int,
    navn varchar(255),
    operatorID int,
    vognType BOOLEAN, --0 for setevogn, 1 for sovevogn
    PRIMARY KEY (vognID),
    FOREIGN KEY (operatorID) REFERENCES Operator(operatorID),
    AUTO_INCREMENT (vognID),
    NOT NULL (vognID, navn, operatorID, vognType)
);

CREATE TABLE SoveVogn (
    vognID int,
    antallKupeer int,
    antallSengerPerKupe int,
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID),
    NOT NULL (vognID, antallKupeer, antallSengerPerKupe)
);

CREATE TABLE SeteVogn (
    vognID int,
    antallRader int,
    antallSeterPerRad int,
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID),
    NOT NULL (vognID, antallRader, antallSeterPerRad)
);

CREATE TABLE VognOppsett (
    vognOppsettID int,
    beskrivelse varchar(255),
    PRIMARY KEY (vognOppsettID),
    AUTO_INCREMENT (vognOppsettID),
    NOT NULL (vognOppsettID)
);

CREATE TABLE VognerPaaVognOppsett (
    vognOppsettID int,
    vognID int,
    rekkefolge int, 
    FOREIGN KEY (vognOppsettID) REFERENCES VognOppsett(vognOppsettID),
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID),
    NOT NULL (vognOppsettID, vognID, rekkefolge)
);

CREATE TABLE Kunde (
    kundeID int,
    firstName varchar(255),
    lastName varchar(255),
    tlfNr varchar(255),
    email varchar(255),
    PRIMARY KEY (kundeID),
    AUTO_INCREMENT (kundeID),
    NOT NULL (kundeID, firstName, lastName, tlfNr, email)
);

CREATE TABLE Kundeordre (
    ordrenummer int,
    kundeID int,
    tidspunkt TIMESTAMP,
    PRIMARY KEY (ordrenummer),
    AUTO_INCREMENT (ordrenummer),
    FOREIGN KEY (kundeID) REFERENCES Kunde(kundeID),
    NOT NULL (kundeID, togruteID, dato)
);

CREATE TABLE Billett (
    billettID int,
    ordrenummer int,
    togruteID int,
    avgangsDato DATE,
    vognID int,
    radNr int,
    seteNr int,
    PRIMARY KEY (billettID),
    FOREIGN KEY (ordrenummer) REFERENCES Kundeordre(ordrenummer),
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID),
    FOREIGN KEY (avgangsDato) REFERENCES Togruteforekomst(dato),
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID),
    AUTO_INCREMENT (billettID),
    NOT NULL (billettID, kundeID, togruteID, avgangsDato, vognID, radNr, seteNr)
);