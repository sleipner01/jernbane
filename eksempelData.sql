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
INSERT INTO Togrute (togruteId, operatorId, vognOppsettId, banestrekningId, hovedretning) VALUES (1, 1, 1, 1, 1);


-- Togruteforekomst


-- TogruteHarDelstrekning


-- Stoppested





-- Kunde


-- Kundeordre


-- Billett