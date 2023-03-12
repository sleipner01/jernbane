-- SQL

CREATE TABLE Banestrekning (
    banestrekningId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(60) NOT NULL,
    fremdriftsenergi varchar(40) NOT NULL,
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    FOREIGN KEY (startStasjonId) REFERENCES Jernbanestasjon(stasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (endeStasjonId) REFERENCES Jernbanestasjon(stasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT CHK_stasjon CHECK (startStasjonId != endeStasjonId)
);

CREATE TABLE Jernbanestasjon (
    stasjonId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(60) NOT NULL,
    moh INTEGER NOT NULL
);

CREATE TABLE Delstrekning (
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    avstand INTEGER NOT NULL,
    sportype BOOLEAN NOT NULL,
    FOREIGN KEY (startStasjonId) REFERENCES Jernbanestasjon(stasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (endeStasjonId) REFERENCES Jernbanestasjon(stasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT PK_Delstrekning PRIMARY KEY (startStasjonId, endeStasjonId),
    CONSTRAINT CHK_stasjon CHECK (startStasjonId != endeStasjonId),
    CONSTRAINT CHK_avstand CHECK (avstand >= 0)
);

CREATE TABLE DelstrekningPaaBanestrekning (
    banestrekningId INTEGER NOT NULL,
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    FOREIGN KEY (banestrekningId) REFERENCES Banestrekning(banestrekningId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (startStasjonId) REFERENCES Delstrekning(startStasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (endeStasjonId) REFERENCES Delstrekning(endeStasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT PK_DelstrekningPaaBanestrekning PRIMARY KEY (banestrekningId, startStasjonId, endeStasjonId)
);

CREATE TABLE Togrute (
    rutenummer INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    operatorId INTEGER NOT NULL,
    vognOppsettId INTEGER NOT NULL,
    banestrekningId INTEGER NOT NULL,
    hovedretning BOOLEAN NOT NULL,
    FOREIGN KEY (operatorId) REFERENCES Operator(operatorId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (vognOppsettId) REFERENCES Operator(vognOppsettId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (banestrekningId) REFERENCES Banestrekning(banestrekningId) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE TogruteHarDelstrekning (
    rutenummer INTEGER NOT NULL,
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    FOREIGN KEY (rutenummer) REFERENCES Togrute(rutenummer) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (startStasjonId) REFERENCES Delstrekning(stasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (endeStasjonId) REFERENCES Delstrekning(stasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT PK_TogruteHarDelstrekning PRIMARY KEY (rutenummer, startStasjonId, endeStasjonId)

);

CREATE TABLE Stoppested (
    rutenummer INTEGER NOT NULL,
    stasjonId INTEGER NOT NULL,
    stoppNummer INTEGER NOT NULL,
    ankomstTid TIME,
    avgangsTid TIME,
    FOREIGN KEY (rutenummer) REFERENCES Togrute(rutenummer) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (stasjonId) REFERENCES Jernbanestasjon(stasjonId) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_Stoppested PRIMARY KEY (rutenummer, stasjonId)
);

CREATE TABLE Togruteforekomst (
    rutenummer INTEGER NOT NULL,
    dato DATE NOT NULL,
    FOREIGN KEY (rutenummer) REFERENCES Togrute(rutenummer) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_Togruteforekomst PRIMARY KEY (rutenummer, dato)
);

CREATE TABLE Operator (
    operatorId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    navn varchar(60) NOT NULL
);

CREATE TABLE Vogn (
    vognId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    operatorId INTEGER NOT NULL,
    vognType BOOLEAN NOT NULL,
    FOREIGN KEY (operatorId) REFERENCES Operator(operatorId) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE SitteVogn (
    vognId INTEGER NOT NULL PRIMARY KEY,
    antallRader INTEGER NOT NULL,
    antallSeterPerRad INTEGER NOT NULL,
    FOREIGN KEY (vognId) REFERENCES Vogn(vognId) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT CHK_antallRader CHECK (antallRader > 0),
    CONSTRAINT CHK_antallSeterPerRad CHECK (antallSeterPerRad > 0)
);

CREATE TABLE SoveVogn (
    vognId INTEGER NOT NULL PRIMARY KEY,
    antallKupeer INTEGER NOT NULL,
    antallSengerPerKupe INTEGER NOT NULL,
    FOREIGN KEY (vognId) REFERENCES Vogn(vognId) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT CHK_antallKupeer CHECK (antallKupeer > 0),
    CONSTRAINT CHK_antallSengerPerKupe CHECK (antallSengerPerKupe > 0)
);


CREATE TABLE VognOppsett (
    vognOppsettId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    beskrivelse varchar(255)
);

CREATE TABLE VognerPaaVognOppsett (
    vognOppsettId INTEGER NOT NULL,
    vognId INTEGER NOT NULL,
    rekkefolge INTEGER NOT NULL, 
    FOREIGN KEY (vognOppsettId) REFERENCES VognOppsett(vognOppsettId) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (vognId) REFERENCES Vogn(vognId) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT PK_VognerPaaVognOppsett PRIMARY KEY (vognOppsettId, vognId),
    CONSTRAINT CHK_rekkefolge CHECK (rekkefolge > 0)
);

CREATE TABLE Kunde (
    kundenummer INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    fornavn varchar(60) NOT NULL,
    etternavn varchar(60) NOT NULL,
    email varchar(60) NOT NULL,
    tlfNr varchar(20) NOT NULL
);

CREATE TABLE Kundeordre (
    ordrenummer INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    kundeId INTEGER NOT NULL,
    tidspunkt datetime NOT NULL,
    FOREIGN KEY (kundeId) REFERENCES Kunde(kundeId) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Billett (
    ordrenummer INTEGER NOT NULL,
    rutenummer INTEGER NOT NULL,
    avgangsDato DATE NOT NULL,
    vognId INTEGER NOT NULL,
    startStasjonId INTEGER NOT NULL,
    endeStasjonId INTEGER NOT NULL,
    plassNr INTEGER NOT NULL,
    FOREIGN KEY (ordrenummer) REFERENCES Kundeordre(ordrenummer) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (rutenummer) REFERENCES Togrute(rutenummer) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (rutenummer, avgangsDato) REFERENCES Togruteforekomst(rutenummer, dato) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (vognId) REFERENCES Vogn(vognId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (startStasjonId) REFERENCES Jernbanestasjon(stasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (endeStasjonId) REFERENCES Jernbanestasjon(stasjonId) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT PK_Billett PRIMARY KEY (ordrenummer, rutenummer, avgangsDato, vognId, startStasjonId, endeStasjonId, plassNr),
    CONSTRAINT CHK_plassNR CHECK (plassNr > 0)
);