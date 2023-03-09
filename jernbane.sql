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




CREATE TABLE Kunde (
    kundeID int,
    firstName varchar(255),
    lastName varchar(255),
    PRIMARY KEY (kundeID),
    AUTO_INCREMENT (kundeID),
    NOT NULL (kundeID, firstName, lastName)
);