#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *
#import "@preview/pintorita:0.1.1"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

= Entwurf <entwurf>

In diesem Kapitel werden die gesammelten Anforderungen aus @anforderungsanalyse verwendet, um die Implementierung in @implementierung vorzubereiten. Hierzu wird zunächst ein Datenbankschema erstellt, um die Datenbank fürs Backend anzupassen (@dbschema). Anschließend werden die Benutzeroberflächen prototypisch geplant (@UI). Im letzten Schritt werden die benötigten Endpunkte des Backends ermittelt (@endpoints).





== Aufbau der Datenbank <dbschema>

Die Erstellung eines Datenbankschemas ist ein wichtiger Schritt. Mit einem vollständigen Datenbankschema wird sichergestellt, dass alle benötigten Daten in der Datenbank gespeichert werden können, dass auf die Daten effizient zugegriffen werden kann und dass die Datenkonsistenz gewährleistet ist. @relationaleDb[Kapitel 3] \ Bei der Konzeption wurde darauf geachtet, dass die entstehende Datenbank in der dritten Normalform vorliegen wird, um Anomalien zu vermeiden (@normalized). @relationaleDb[Kapitel 9]\
Im ersten Schritt wurden Tabellen für Module und Teilmodule geplant. Damit das System auch für alle Fakultäten und alle Studiengänge nutzbar ist, wurden zusätzlich die Tabellen Faculty und Course geplant.  
Um die Anforderungen @SHOWCHANGES und @REVERT vorzubereiten, wurde die Tabelle Changelog genutzt.
Die bestehende User-Tabelle wurden an verschiedenen Stellen referenziert, um beispielsweise die verantwortlichen Personen anzugeben.
Eigenschaften, die aus @requirements oder aus @properties hervorgehen, sind dementsprechend markiert.

#diagramFigure("ER-Diagramm - Gesamtbild", <ER>, "ER")


Um die Anforderung @TRANSLATEMULTIPLE vorzubereiten, wurde die Tabelle TranslatedText für alle Eigenschaften mit dem Datentyp "TEXT" genutzt. Zur besseren Lesbarkeit wurde dies nur exemplarisch für die Eigenschaften E1-E3 dargestellt:

#diagramFigure("ER-Diagramm - TranslatedText", <ER_TRANS>, "ER_Translation")



== Benutzeroberflächen <UI>

Im Folgenden wird mithilfe von Mockups entworfen, wie die Benutzeroberflächen der neuen Anwendung aussehen sollen. Da an Mockups schnell Änderungen vorgenommen werden können, soll dieser Prozess dabei helfen, zeiteffizient gute Lösungen zu finden. Es werden zunächst in @scaffold die Elemente zur Navigation durch die Anwendung vorgestellt. Anschließend werden in @views die verschiedenen Ansichten skizziert.

Flat Design

UI-Patterns Vorlesung um 22.04.
Folie 37/38


/*

Usability / User Experience Definition  \
DIN 9241-210

Benutzungsschnittstelle\
DIN 9241-110

max. 7 Informationen gleichzeitig verarbeiten \
https://lexikon.stangl.eu/2912/chunks
Miller, George A. (1956). The Magical Number 7, Plus or Minus Two: Some Limits on Our Capacity for Processing Information. Psychological Review, 63, pp. 81-97. (Stangl, 2024).

*/


=== Grundgerüst <scaffold>

Um mit möglichst wenig Aufwand (@CLICKS) jederzeit die Suchfunktion (@SEARCH) nutzen zu können, wird diese in der oberen Leiste (Toolbar) platziert. Neben der Suche ist ein Dropdown, mit dem die angezeigte Sprache umgestellt werden kann (@TRANSLATEMULTIPLE). Die Toolbar ist in jeder Ansicht zu sehen. Unter der Toolbar ist die eigentliche Anwendung zu sehen, die aus verschiedenen Ansichten besteht. Damit jederzeit erkenntlich ist, in welcher Ansicht sich der User befindet (@PATH), wird diese Information als Breadcrumb auf der Toolbar platziert.



#imageFigure(<grundgerüst>, "mockups/Grundgerüst.svg", "Grundgerüst")

Funktionen, die nicht oft benötigt werden, werden in einer ausklappbaren Seitenleiste (Drawer) platziert. Die Seitenleiste kann mithilfe eines Knopfes ausgeklappt werden, welcher sich auf der Toolbar befindet. Somit können auch diese Funktionen mit wenig Aufwand (@CLICKS) von jeder Ansicht aus erreicht werden. Im Drawer sind die Masken zur Verwaltung der Benutzer (@CRUSER), zur Anzeige gelöschter Module (@SOFTDELETE) und zur Ansicht alter Prüfungsordnungen. Außerdem wird hier die Versionsnummer angezeigt, damit jederzeit überprüft werden kann, mit welcher Version des Systems gearbeitet wird.


#imageFigure(<drawer>, "mockups/Drawer.png", "Drawer")


=== Komponenten <views>

#heading(level: 4, numbering:none, "Suchfunktion")
Für die Suchfunktion wird eine Komponente benötigt, mit der ein User ein bestimmtes Modul finden kann. Hierzu soll ein Text eingegeben werden. Module die zu dem Text passen, sollen vorgeschlagen werden. Der User kann einen Vorschlag anklicken, um sich dieses Modul anzusehen.

#imageFigure(<search>, "mockups/Search.svg", "Suche mit Dropdown")

#heading(level: 4, numbering:none, "Modulübersicht")


- Filterfunktion

- Modul anlegen / bearbeiten

- Übersetzbarkeit

- User anlegen

- Änderungen rückgängig machen

- Prüfungsordnung verifizieren




== Benötigte Endpunkte im Backend <endpoints>