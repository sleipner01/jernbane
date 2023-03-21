SELECT * FROM Jernbanestasjon 
JOIN Stoppested ON Stoppested.stasjonId = Jernbanestasjon.stasjonId
JOIN Togrute ON Stoppested.rutenummer = Togrute.rutenummer
JOIN Togruteforekomst ON Togruteforekomst.rutenummer = Togrute.rutenummer
WHERE Jernbanestasjon.navn = "Trondheim" AND Togruteforekomst.dato =  "2023-03-21"