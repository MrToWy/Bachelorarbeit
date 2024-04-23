#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *
#import "@preview/pintorita:0.1.1"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

= Entwurf <entwurf>

In diesem Kapitel werden die Ergebnisse aus @anforderungsanalyse verwendet, um @implementierung vorzubereiten. Hierzu wird ein Datenbankschema erstellt, um die Datenbank fürs Backend anzupassen. Anschließend werden die Benutzeroberflächen prototypisch geplant. Im letzten Schritt werden die benötigten Endpunkte des Backends ermittelt.





== Datenbankschema <dbschema>

Die Erstellung eines Datenbankschemas ist ein wichtiger Schritt. Mit einem vollständigen Datenbankschema wird sichergestellt, dass alle benötigten Daten in der Datenbank gespeichert werden können, dass auf die Daten effizient zugegriffen werden kann und dass die Datenkonsistenz gewährleistet ist. @relationaleDb[Kapitel 3] \ Bei der Konzeption wurde darauf geachtet, dass die entstehende Datenbank in der dritten Normalform vorliegen wird, um Anomalien zu vermeiden (@normalized). @relationaleDb[Kapitel 9]\
Im ersten Schritt wurden Tabellen für Module und Teilmodule geplant. Damit das System auch für alle Fakultäten und alle Studiengänge nutzbar ist, wurden zusätzlich die Tabellen Faculty und Course geplant.  
Um die Anforderungen @SHOWCHANGES und @REVERT vorzubereiten, wurde die Tabelle Changelog genutzt.
Die bestehende User-Tabelle wurden an verschiedenen Stellen referenziert, um beispielsweise die verantwortlichen Personen anzugeben.
Eigenschaften, die aus @requirements oder aus @properties hervorgehen, sind dementsprechend markiert.

#diagramFigure("ER-Diagramm - Gesamtbild", <ER>, "ER")


Um die Anforderung @TRANSLATEMULTIPLE vorzubereiten, wurde die Tabelle TranslatedText für alle Eigenschaften mit dem Datentyp "TEXT" genutzt. Zur besseren Lesbarkeit wurde dies nur exemplarisch für die Eigenschaften E1-E3 dargestellt:

#diagramFigure("ER-Diagramm - TranslatedText", <ER_TRANS>, "ER_Translation")



== Benutzeroberflächen <UI>
Flat Design

UI-Patterns Vorlesung um 22.04.
Folie 37/38

=== Usability

/*

Usability / User Experience Definition  \
DIN 9241-210

Benutzungsschnittstelle\
DIN 9241-110

max. 7 Informationen gleichzeitig verarbeiten \
https://lexikon.stangl.eu/2912/chunks
Miller, George A. (1956). The Magical Number 7, Plus or Minus Two: Some Limits on Our Capacity for Processing Information. Psychological Review, 63, pp. 81-97. (Stangl, 2024).

*/


=== Grundgerüst

=== Prototyp


== Benötigte Endpunkte im Backend