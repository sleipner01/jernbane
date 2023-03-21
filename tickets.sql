-- Henter billetter

SELECT Togrute.rutenummer as Rute, Billett.avgangsDato as avreise, VognerPaaVognOppsett.rekkefolge, Billett.plassNr FROM Togrute
JOIN Togruteforekomst ON Togrute.rutenummer = Togrute.rutenummer
JOIN Billett ON Togrute.rutenummer = Billett.rutenummer
JOIN VognerPaaVognOppsett ON VognerPaaVognOppsett.vognId = Billett.vognId