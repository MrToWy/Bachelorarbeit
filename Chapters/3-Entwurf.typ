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

Im Folgenden wird mithilfe von Mockups entworfen, wie die Benutzeroberflächen der neuen Anwendung aussehen sollen. Da an Mockups schnell Änderungen vorgenommen werden können, soll dieser Prozess dabei helfen, zeiteffizient gute Lösungen zu finden. Es werden zunächst in @scaffold die Elemente zur Navigation durch die Anwendung vorgestellt. Anschließend werden in @views die verschiedenen Komponenten der Anwendung, sowie die daraus zusammengesetzten Ansichten skizziert.



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
Die Oberfläche der Anwendung besteht aus einer Toolbar und einem ausklappbaren Drawer. Unter der Toolbar ist die eigentliche Anwendung zu sehen, die aus verschiedenen Ansichten besteht. Die Toolbar ist in jeder Ansicht zu sehen. Diese Art der Navigation ist mittlerweile Standard und sollte für den Großteil der User selbsterklärend sein. @designInterfaces[Seite 131] 

#let toolbarText = [
Um mit möglichst wenig Aufwand (@CLICKS) jederzeit die Suchfunktion (@SEARCH) nutzen zu können, wird diese in der oberen Leiste (Toolbar) platziert. Neben der Suche ist ein Dropdown, mit dem die angezeigte Sprache umgestellt werden kann (@TRANSLATEMULTIPLE).  Damit jederzeit erkenntlich ist, in welcher Ansicht sich der User befindet (@PATH), wird diese Information als Breadcrumb auf der Toolbar platziert.
]

#let toolbarImage = imageFigureNoPad(<grundgerüst>, "mockups/Grundgerüst.svg", "Toolbar")

#let boxedToolbarImage = box(toolbarImage, inset: 0.5em)

#wrap-content(align: bottom + right,
column-gutter: 1em,
boxedToolbarImage, toolbarText)



#let drawerText = [Funktionen, die nicht oft benötigt werden, werden in einer ausklappbaren Seitenleiste (Drawer) platziert. Die Seitenleiste kann mithilfe eines Knopfes ausgeklappt werden, welcher sich auf der Toolbar befindet. Somit können auch diese Funktionen mit wenig Aufwand (@CLICKS) von jeder Ansicht aus erreicht werden. Im Drawer sind die Masken zur Verwaltung der Benutzer (@CRUSER), zur Anzeige gelöschter Module (@SOFTDELETE) und zur Ansicht alter Prüfungsordnungen. Außerdem wird hier die Versionsnummer angezeigt, damit jederzeit überprüft werden kann, mit welcher Version des Systems gearbeitet wird.]


#let drawerImage = imageFigureNoPad(width: 40%,
  <drawer>, "mockups/Drawer.png", "Drawer")

#wrap-content(align: bottom + right, drawerImage, drawerText)
//#drawerText
//#drawerImage

=== Komponenten <views>



#let searchFunctionImage = imageFigureNoPad(<search>, "mockups/Search.png", "Suche mit Dropdown", width: 6em)

#let searchFunctionText = [
  #heading(level: 4, numbering:none, "Suchfunktion")
  Für die Suchfunktion wird eine Komponente benötigt, mit der ein bestimmtes Modul gefunden werden kann. In die Suchleiste soll der User den Namen des gesuchten Modules eingeben können. Dabei muss der Modulname nicht vollständig eingegeben werden. Module, die zu dem eingebenen Text passen, sollen vorgeschlagen werden. Durch die Vorschläge spart der User Zeit, da nicht der vollständige Modulname eingegeben werden muss und auch nicht erst zu einer Ergebnisseite weitergeleitet wird. @designInterfaces[Seite 502 ff.] Der User kann einen Vorschlag anklicken, um sich dieses Modul anzusehen.

]

#let boxed = box(searchFunctionImage, inset: 0.5em)
#wrap-content(align: bottom + right, boxed, searchFunctionText)




#heading(level: 4, numbering:none, "Modulübersicht")
- Filterfunktion

#heading(level: 4, numbering:none, "Modul anlegen / bearbeiten")


 
#let translateText = [
Für die Erstellung oder Bearbeitung eines Moduls kann entweder ein vorhandener Text aus einem Dropdown ausgewählt werden, oder ein neuer Text durch klicken auf den "Neu"-Button angelegt werden. Wenn ein neuer Text angelegt wird, muss der User einen Kurztext angeben, der im Dropdown angezeigt wird, sowie die tatsächlichen Texte, die später im Modulhandbuch abgebildet werden. 
]

#let translateDropdownImage = imageFigureNoPad(<translateDropdown>, "mockups/ÜbersetzbarkeitDropdown.svg", "Dropdown zur Textauswahl", width: 16em)

#let translateImage = imageFigureNoPad(<translatePopup>, "mockups/Übersetzbarkeit.svg", "Neuen Text hinzufügen", width: 16em)

#let translationBoxed = box(inset: 0.5em)[#translateDropdownImage #translateImage]

#wrap-content(align: bottom + right, translationBoxed, translateText)

//#translateText
//#translateDropdownImage
//#translateImage

- User anlegen

- Änderungen rückgängig machen

- Prüfungsordnung verifizieren




== Benötigte Endpunkte im Backend <endpoints>

Damit das zukünftige Frontend mit dem  Backend kommunizieren kann, muss das Backend Endpunkte bereitstellen, die das Frontent nutzen kann. Ein Endpoint ist beispielsweise die Auflistung aller Module und ist mithilfe einer URI aufrufbar (hier z.B. /modules). Ein einzelnes Modul könnte über die Ressource /modules/{id} aufgerufen werden. @restUndHTTP[Abschnitt 3.2]

In der vorliegenden Version des "StudyBase-"Backends gibt es bereits mehrere Resourcen. Im folgenden soll ermittelt werden, welche Ressourcen für das neue System benötigt werden. Nach dem YAGNI-Prinzip sollen dann in 
@implementierung nur die Resourcen ausgearbeitet werden, die für das neue System benötigt werden. @restUndHTTP[Unterabschnitt 4.2.8]

Im zukünftigen Frontend sollen an verschiedenen Stellen die Module aufgelistet werden. Die Suchfunktion soll Vorschläge anhand der Modulliste machen, die Studiengänge sollen ihre Module anzeigen und die studiengangsverantwortliche Person soll alle Module verwalten können. Es wird also eine Resource benötigt, die alle Module auflistet. Für die Suchfunktion muss die Resource allerdings weniger Informationen anzeigen, als für die Auflistungen in der Verwaltungsoberfläche. 

#heading(level: 4, numbering: none)[Endpunkt /modules]
  Die Suchfunktion benötigt:
1. den Namen des Moduls, um einen Vorschlag anzuzeigen (@search)
2. die Id des Moduls, um die Detailansicht zu dem Modul öffnen zu können
3. den Studiengang des Moduls, um die Ergebnisse gruppieren zu können (@search)
Die Tabellen im restlichen System profizieren dahingegen von zusätzlichen Informationen. Diese können dabei helfen, die Module zu filtern (@FILTER), oder schnell Informationen zu einem Modul herauszufinden, ohne dieses aufrufen zu müssen. 

Es werden also die folgenden Informationen zusätzlich benötigt:
4. Semester, in dem das Modul vorgeschlagen ist (@recommendedSemester), um beispielsweise nur die Module des aktuellen Semester zu filtern 
5. Ansprechpartner (@responsible), um schnell eine Kontaktinformation zu erhalten
#todo(inline:true)[Ansprechpartner als Use-Case?]


#heading(level: 4, numbering: none)[Endpunkt /modules/{id}]
  Hier sollten alle Informationen zur Verfügung gestellt werden, die für die Detailansichten eines einzelnen Moduls benötigt werden. Es müssen also alle Informationen aus @properties enthalten sein.


#heading(level: 4, numbering: none)[Endpunkt /modules/{id}]a 