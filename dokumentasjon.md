# Dokumentasjon

## Antakelser

 - Det er ikke vits i å lage egne entiteter for kupeer og seter. Oppgaven spesifiserer ikke et vogn-layout som ikke er repetativt. Ved å beskrive en vogn med enten (antall rader x antall seter per rad), eller (antall kupeer x antall senger per kupe) kan man regne seg fram til hvilke billetter som er gyldige, og hvilken rad-sete billetten er for. Å lage egne tabeller for å spesifisere sete&rad for hver eneste vogn vil danne utrolig mye repetativ data, som heller - og mere effektivt kan utregnes. 

## Restriksjoner som ikke er uttrykket i ER-modellen og må implementeres i applikasjonen

 - Hovedretning
   - Delstrekning: startStasjon -> endeStasjon indikerer hovedretningen


 - Delstrekning
   - Det skal ikke være mulig å lagre en banestrekning hvor start- og endestasjon er byttet om. 

 - Billetter
   - Bruke "plassNr" Regne ut hvilken kupe en billett viser til og avgjøre hvilke kupeer som kan selges til andre kunder.
   - Eventuelt bruke "plassNr" til å regne ut hvilken rad og sete en billett gjelder.
   - Avgjøre om seter er ledige basert på start-slutt på andre billetter.
   - Databaseen tillater å kjøpe billetter som overlapper andre billetter. Enten man kjøper billetter som overlapper fullstendig, eller har start- eller endestasjon i som er et stopp mellom en annen billett for setet. Dette er en restriksjon som må programmeres.

 - VognerPaaVognoppsett
   - Sjekke at det ikke allerede finnes en annen vogn på samme plass i rekkefølgen.
   - Sjekke at det finnes en vogn med indeks-1 (en vogn foran den som plasseres)

## Forklaring av verdier

 - Delstrekning:
   - `sportype`
     - `BOOLEAN`
       - 0: Enkeltspor
       - 1: Dobbeltspor

   - Togrute:
     - `hovedretning`
       - `BOOLEAN`
         - 0: Mot hovedretning
         - 1: Hovedretning  

  - Vogn
    - `type`
      - `BOOLEAN`
        - 0: Setevogn
        - 1: Sovevogn