-- SQL

CREATE TABLE Banestrekning (
    banestrekningID int NOT NULL AUTO_INCREMENT,
    navn varchar(255) NOT NULL,
    PRIMARY KEY (banestrekningID)
);

CREATE TABLE Jernbanestasjon (
    stasjonID int NOT NULL AUTO_INCREMENT,
    navn varchar(255) NOT NULL,
    moh int NOT NULL,
    PRIMARY KEY (stasjonID)
);

CREATE TABLE Delstrekning (
    startStasjonID int NOT NULL,
    endeStasjonID int NOT NULL,
    avstand int NOT NULL,
    sportype BOOLEAN NOT NULL,
    FOREIGN KEY (startStasjonID) REFERENCES Jernbanestasjon(stasjonID),
    FOREIGN KEY (endeStasjonID) REFERENCES Jernbanestasjon(stasjonID)
);

CREATE TABLE DelstrekningPaaBanestrekning (
    banestrekningID int NOT NULL,
    startStasjonID int NOT NULL,
    endeStasjonID int NOT NULL,
    FOREIGN KEY (banestrekningID) REFERENCES Banestrekning(banestrekningID),
    FOREIGN KEY (startStasjonID) REFERENCES Delstrekning(startStasjonID),
    FOREIGN KEY (endeStasjonID) REFERENCES Delstrekning(endeStasjonID)
);

CREATE TABLE Togrute (
    togruteID int NOT NULL AUTO_INCREMENT,
    operatorID int NOT NULL,
    vognOppsettID int NOT NULL,
    hovedretning BOOLEAN NOT NULL,
    FOREIGN KEY (operatorID) REFERENCES Operator(operatorID),
    FOREIGN KEY (vognOppsettID) REFERENCES Operator(vognOppsettID)
);

CREATE TABLE Stoppested (
    togruteID int NOT NULL,
    stasjonID int NOT NULL,
    stoppNummer int NOT NULL,
    ankomstKlokkeslett TIME,
    avgangKlokkeslett TIME,
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID),
    FOREIGN KEY (stasjonID) REFERENCES Jernbanestasjon(stasjonID)
);

CREATE TABLE Togruteforekomst (
    togruteID int NOT NULL,
    dato DATE NOT NULL,
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID)
);

CREATE TABLE Operator (
    operatorID int NOT NULL AUTO_INCREMENT,
    navn varchar(255) NOT NULL,
    PRIMARY KEY (operatorID)
);

CREATE TABLE Vogn (
    vognID int NOT NULL AUTO_INCREMENT,
    navn varchar(255) NOT NULL,
    operatorID int NOT NULL,
    vognType BOOLEAN NOT NULL,
    PRIMARY KEY (vognID),
    FOREIGN KEY (operatorID) REFERENCES Operator(operatorID)
);

CREATE TABLE SoveVogn (
    vognID int NOT NULL,
    antallKupeer int NOT NULL,
    antallSengerPerKupe int NOT NULL,
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID)
);

CREATE TABLE SeteVogn (
    vognID int NOT NULL,
    antallRader int NOT NULL,
    antallSeterPerRad int NOT NULL,
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID)
);

CREATE TABLE VognOppsett (
    vognOppsettID int NOT NULL AUTO_INCREMENT,
    beskrivelse varchar(255),
    PRIMARY KEY (vognOppsettID)
);

CREATE TABLE VognerPaaVognOppsett (
    vognOppsettID int NOT NULL,
    vognID int NOT NULL,
    rekkefolge int NOT NULL, 
    FOREIGN KEY (vognOppsettID) REFERENCES VognOppsett(vognOppsettID),
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID)
);

CREATE TABLE Kunde (
    kundeID int NOT NULL AUTO_INCREMENT,
    firstName varchar(255) NOT NULL,
    lastName varchar(255) NOT NULL,
    tlfNr varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    PRIMARY KEY (kundeID)
);

CREATE TABLE Kundeordre (
    ordrenummer int NOT NULL AUTO_INCREMENT,
    kundeID int NOT NULL,
    tidspunkt TIMESTAMP NOT NULL,
    PRIMARY KEY (ordrenummer),
    FOREIGN KEY (kundeID) REFERENCES Kunde(kundeID)
);

CREATE TABLE Billett (
    billettID int NOT NULL  AUTO_INCREMENT,
    ordrenummer int NOT NULL,
    togruteID int NOT NULL,
    avgangsDato DATE NOT NULL,
    vognID int NOT NULL,
    radNr int NOT NULL,
    seteNr int NOT NULL,
    PRIMARY KEY (billettID),
    FOREIGN KEY (ordrenummer) REFERENCES Kundeordre(ordrenummer),
    FOREIGN KEY (togruteID) REFERENCES Togrute(togruteID),
    FOREIGN KEY (avgangsDato) REFERENCES Togruteforekomst(dato),
    FOREIGN KEY (vognID) REFERENCES Vogn(vognID)
);