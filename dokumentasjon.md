# Dokumentasjon

## Antakelser

 - Det er ikke vits i å lage egne entiteter for kupeer og seter. Oppgaven spesifiserer ikke et vogn-layout som ikke er repetativt. Ved å beskrive en vogn med enten (antall rader x antall seter per rad), eller (antall kupeer x antall senger per kupe) kan man regne seg fram til hvilke billetter som er gyldige, og hvilken rad-sete billetten er for. Å lage egne tabeller for å spesifisere sete&rad for hver eneste vogn vil danne utrolig mye repetativ data, som heller - og mere effektivt kan utregnes. 

## Restriksjoner som ikke er uttrykket i ER-modellen og må implementeres i applikasjonen

 - Hovedretning
   - Delstrekning: startStasjon -> endeStasjon indikerer hovedretningen
   - Togrute:
     - 0: Mot hovedretning
     - 1: Hovedretning  

 - Billetter
   - Bruke "plassNr" Regne ut hvilken kupe en billett viser til og avgjøre hvilke kupeer som kan selges til andre kunder.
   - Eventuelt bruke "plassNr" til å regne ut hvilken rad og sete en billett gjelder.
   - Avgjøre om seter er ledige basert på start-slutt på andre billetter.

## Forklaring av verdier

 - `sportype`
   - `BOOLEAN`
     - 0: Enkeltspor
     - 1: Dobbeltspor


  - Vogn
    - `type`
      - 0: Setevogn
      - 1: Sovevogn