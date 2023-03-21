-- Jernbanestasjoner
INSERT INTO Jernbanestasjon (stasjonId, navn, moh) VALUES (1, 'Bodø', 4.1);
INSERT INTO Jernbanestasjon (stasjonId, navn, moh) VALUES (2, 'Fauske', 34.0);
INSERT INTO Jernbanestasjon (stasjonId, navn, moh) VALUES (3, 'Mo i Rana', 3.5);
INSERT INTO Jernbanestasjon (stasjonId, navn, moh) VALUES (4, 'Mosjøen', 6.8);
INSERT INTO Jernbanestasjon (stasjonId, navn, moh) VALUES (5, 'Steinkjær', 3.6);
INSERT INTO Jernbanestasjon (stasjonId, navn, moh) VALUES (6, 'Trondheim', 5.1);

-- Delstrekninger
INSERT INTO Delstrekning (startStasjonId, endeStasjonId, avstand, sportype) VALUES (1, 2, 60, 0);
INSERT INTO Delstrekning (startStasjonId, endeStasjonId, avstand, sportype) VALUES (2, 3, 170, 0);
INSERT INTO Delstrekning (startStasjonId, endeStasjonId, avstand, sportype) VALUES (3, 4, 90, 0);
INSERT INTO Delstrekning (startStasjonId, endeStasjonId, avstand, sportype) VALUES (4, 5, 280, 0);
INSERT INTO Delstrekning (startStasjonId, endeStasjonId, avstand, sportype) VALUES (5, 6, 120, 1);

-- Banestrekninger
INSERT INTO Banestrekning (banestrekningId, navn, fremdriftsenergi, startStasjonId, endeStasjonId) VALUES (1, 'Nordlandsbanen', 'Diesel', 1, 2);

-- Delstrekninger på banestrekninger
INSERT INTO DelstrekningPaaBanestrekning (banestrekningId, startStasjonId, endeStasjonId) VALUES (1, 1, 2);
INSERT INTO DelstrekningPaaBanestrekning (banestrekningId, startStasjonId, endeStasjonId) VALUES (1, 2, 3);
INSERT INTO DelstrekningPaaBanestrekning (banestrekningId, startStasjonId, endeStasjonId) VALUES (1, 3, 4);
INSERT INTO DelstrekningPaaBanestrekning (banestrekningId, startStasjonId, endeStasjonId) VALUES (1, 4, 5);
INSERT INTO DelstrekningPaaBanestrekning (banestrekningId, startStasjonId, endeStasjonId) VALUES (1, 5, 6);





-- Operator
INSERT INTO Operator (operatorId, navn) VALUES (1, 'Vy');

-- Vogn
INSERT INTO Vogn (vognId, operatorId, vognType) VALUES (1, 1, 0); -- Sittevogn-1
INSERT INTO Vogn (vognId, operatorId, vognType) VALUES (2, 1, 0); -- Sittevogn-2
INSERT INTO Vogn (vognId, operatorId, vognType) VALUES (3, 1, 0); -- Sittevogn-3
INSERT INTO Vogn (vognId, operatorId, vognType) VALUES (4, 1, 0); -- Sittevogn-4
INSERT INTO Vogn (vognId, operatorId, vognType) VALUES (5, 1, 1); -- Sovevogn-1

-- Sittevogn
INSERT INTO Sittevogn (vognId, antallRader, antallSeterPerRad) VALUES (1, 3, 4);
INSERT INTO Sittevogn (vognId, antallRader, antallSeterPerRad) VALUES (1, 3, 4);

-- Sovevogn
INSERT INTO Sovevogn (vognId, antallKupeer, antallSengerPerKupe) VALUES (2, 4, 2);

-- Vognoppsett
INSERT INTO Vognoppsett (vognOppsettId, beskrivelse) VALUES (1, 'To sittevogner');

-- VognerPaaVognoppsett
-- Dagtog Trondheim - Bodø
INSERT INTO VognerPaaVognoppsett (vognOppsettId, vognId, rekkefolge) VALUES (1, 1, 1); -- Sittevogn-1
INSERT INTO VognerPaaVognoppsett (vognOppsettId, vognId, rekkefolge) VALUES (1, 2, 2); -- Sittevogn-2
-- Nattog Trondheim - Bodø
INSERT INTO VognerPaaVognoppsett (vognOppsettId, vognId, rekkefolge) VALUES (1, 3, 1); -- Sittevogn-3
INSERT INTO VognerPaaVognoppsett (vognOppsettId, vognId, rekkefolge) VALUES (1, 4, 2); -- Sovevogn-1
-- Morgentog Mo i Rana til Trondheim
INSERT INTO VognerPaaVognoppsett (vognOppsettId, vognId, rekkefolge) VALUES (1, 1, 1); -- Sittevogn-4



-- Togrute
INSERT INTO Togrute (rutenummer, operatorId, vognOppsettId, banestrekningId, hovedretning) VALUES (1, 1, 1, 1, 1); -- Dagtog Trondheim - Bodø
INSERT INTO Togrute (rutenummer, operatorId, vognOppsettId, banestrekningId, hovedretning) VALUES (2, 1, 2, 1, 1); -- Nattog Trondheim - Bodø
INSERT INTO Togrute (rutenummer, operatorId, vognOppsettId, banestrekningId, hovedretning) VALUES (3, 1, 3, 1, 0); -- Morgentog Mo i Rana -Trondheim


-- Togruteforekomst
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (1, '2023-03-20'); -- Mandag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (1, '2023-03-21'); -- Tirsdag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (1, '2023-03-22'); -- Onsdag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (1, '2023-03-23'); -- Torsdag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (1, '2023-03-24'); -- Fredag

INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (2, '2023-03-20'); -- Mandag 
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (2, '2023-03-21'); -- Tirsdag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (2, '2023-03-22'); -- Onsdag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (2, '2023-03-23'); -- Torsdag 
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (2, '2023-03-24'); -- Fredag 
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (2, '2023-03-25'); -- Lørdag 
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (2, '2023-03-26'); -- Søndag

INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (3, '2023-03-20'); -- Mandag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (3, '2023-03-21'); -- Tirsdag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (3, '2023-03-22'); -- Onsdag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (3, '2023-03-23'); -- Torsdag
INSERT INTO Togruteforekomst (rutenummer, dato) VALUES (3, '2023-03-24'); -- Fredag


-- TogruteHarDelstrekning
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (1, 1, 2); -- Dagtog Trondheim - Bodø
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (1, 2, 3); -- Dagtog Trondheim - Bodø
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (1, 3, 4); -- Dagtog Trondheim - Bodø
INSERT INTO TOgruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (1, 4, 5); -- Dagtog Trondheim - Bodø
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (1, 5, 6); -- Dagtog Trondheim - Bodø

INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (2, 1, 2); -- Nattog Trondheim - Bodø
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (2, 2, 3); -- Nattog Trondheim - Bodø
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (2, 3, 4); -- Nattog Trondheim - Bodø
INSERT INTO TOgruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (2, 4, 5); -- Nattog Trondheim - Bodø
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (2, 5, 6); -- Nattog Trondheim - Bodø

INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (3, 1, 2); -- Morgentog Mo i Rana - Trondheim
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (3, 2, 3); -- Morgentog Mo i Rana - Trondheim
INSERT INTO TogruteHarDelstrekning (rutenummer, startStasjonId, endeStasjonId) VALUES (3, 3, 4); -- Morgentog Mo i Rana - Trondheim

-- Stoppested
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (1, 1, 1, null, '07:59'); -- Dagtog Trondheim - Bodø | Trondheim
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (1, 2, 2, '09:58', '09:59'); -- Dagtog Trondheim - Bodø | Steinkjær
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (1, 3, 3, '13:19', '13:20'); -- Dagtog Trondheim - Bodø | Mosjøen
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (1, 4, 4, '14:30', '14:31'); -- Dagtog Trondheim - Bodø | Mo i Rana
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (1, 5, 5, '16:48', '16:49'); -- Dagtog Trondheim - Bodø | Fauske
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (1, 6, 6, '17:34', null); -- Dagtog Trondheim - Bodø | Bodø

INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (2, 1, 1, null, '23:05'); -- Nattog Trondheim - Bodø | Trondheim
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (2, 2, 2, '00:06', '00:57'); -- Nattog Trondheim - Bodø | Steinkjær
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (2, 3, 3, '04:40', '04:41'); -- Nattog Trondheim - Bodø | Mosjøen
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (2, 4, 4, '05:54', '05:55'); -- Nattog Trondheim - Bodø | Mo i Rana
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (2, 5, 5, '08:18', '08:19'); -- Nattog Trondheim - Bodø | Fauske
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (2, 6, 6, '09:05', null); -- Nattog Trondheim - Bodø | Bodø

INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (3, 4, 1, null, '08:11'); -- Morgentog Mo i Rana - Trondheim | Mo i Rana
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (3, 3, 2, '09:13', '09:14'); -- Morgentog Mo i Rana - Trondheim | Mosjøen
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (3, 2, 3, '12:30', '12:31'); -- Morgentog Mo i Rana - Trondheim | Steinkjær
INSERT INTO Stoppested (rutenummer, stasjonId, stoppNummer, ankomstTid, avgangTid) VALUES (3, 1, 4, '14:13', null); -- Morgentog Mo i Rana - Trondheim | Trondheim



-- Kunde
INSERT INTO Kunde (kundenummer, fornavn, etternavn, email, tlfNr) VALUES (1, 'Ola', 'Nordmann', 'ola.nordmann@hotmail.com', '12345678');
INSERT INTO Kunde (kundenummer, fornavn, etternavn, email, tlfNr) VALUES (2, 'Kari', 'Nordmann', 'kari.nordmann@hotmail.com', '22345678');

-- Kundeordre


-- Billett