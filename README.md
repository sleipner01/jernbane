# Jernbane🛤️

## Forfattere

[Magnus Byrkjeland](https://github.com/sleipner01), [Johannes Meldal](https://github.com/johannesmeldal) og [Magnus Ouren](https://github.com/magnusouren)

## Oppgavebesvarelser

Brukerhistoriene fra prosjektbeskrivelsen er besvart i sepparerte filer. US-("userstory")Bokstav

## ER-Diagram

ER-Diagrammet til vår databasemodell er beskrevet i `ER.png`. Denne er vidre forklart i tekstfilen til besvarelsen

## Databasetabeller

Entitetklassene og relasjonsklassene er videre definert i `jernbane.sql`. Tabellene er resultat av ER-modellen.

## Eksempeldata

Eksempeldata brukt for å løse oppgavene er lagt i `eksempelData.sql`. Dette er data som må ligge i databasen for å kunne løse oppgavene.

## Kjøring av sql filer

`runFile.py`er lagt til for å kjøre scriptene fra .sql-filene. Per nå brukes dette for å slette eventuel nåværende data i databasen, opprette alle tabeller og legge til eksempeldataen fra fil.

## Verdier
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
