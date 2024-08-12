#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *
#import "@preview/pintorita:0.1.1"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

= Entwurf <entwurf>

In diesem Kapitel werden die gesammelten Anforderungen aus @anforderungsanalyse verwendet, um die Implementierung in @implementierung vorzubereiten. Hierzu wird zunächst ein Datenbankschema erstellt, um die Datenbank fürs Backend anzupassen (@dbschema). Anschließend werden die Benutzeroberflächen prototypisch geplant (@UI). Im letzten Schritt werden die benötigten Endpunkte des Backends ermittelt (@endpoints).

Die Entwurfsphase ist für die Entwicklung des Systems wichtig, damit grundlegende Entscheidungen möglichst früh getroffen werden. Wenn die Entwicklung des Systems bereits begonnen hat, benötigen nachträgliche Änderungen oft einen höheren Aufwand. Durch einen guten Entwurf soll die Implementierung beschleunigt werden, da in der Implementierungsphase dann weniger Entscheidungen getroffen werden müssen. @kleuker_grundkurs_2013 





== Aufbau der Datenbank <dbschema>

Die Erstellung eines Datenbankschemas ist ein wichtiger Schritt. Mit einem vollständigen Datenbankschema wird sichergestellt, dass alle benötigten Daten in der Datenbank gespeichert werden können, dass auf die Daten effizient zugegriffen werden kann und dass die Datenkonsistenz gewährleistet ist. @relationaleDb[Kapitel 3] 

Die Datenbankschemas werden mithilfe der Krähenfußnotation @relationaleDb[Seite 26] erstellt. Die Bedeutung der Kardinalitäten ist in @kardinalitäten erklärt. @EntityRelationshipDiagram

#figure(caption: "Notation der Kardinalitäten")[
  #table(
  columns: (auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Zeichen*], [*Bedeutung*],
  ),
  [o|],[0 oder eins],
  [||],[genau eins],
  [o{],[0 oder mehrere],
  [|{],[eins oder mehrere],
)
]<kardinalitäten> 


=== Benötigte Tabellen
Für die Kernfunktionalität werden zunächst Tabellen für Module und Teilmodule benötigt. Um die Organisationsstruktur der Hochschule abbilden zu können, werden weiterhin Tabellen für Fakultäten, Abteilungen und Studiengänge benötigt. Damit ein Login möglich ist, kann die Tabelle User benutzt werden. Für die Anforderung @SHOWCHANGES wird eine Tabelle Changelog und eine Tabelle ChangelogItem benötigt. In der Tabelle Changelog wird für jede Änderung ein Eintrag eingetragen, welcher den ausführenden User und eine kurze Zusammenfassung beinhaltet. In den ChangelogItems stehen dann die konkreten geänderten Felder. Damit ein Modul einer Gruppe zugewiesen werden kann, wird eine Tabelle ModuleGroup benötigt, in der alle verfügbaren Gruppen aufgelistet sind. Des Weiteren werden noch die Tabelle "Job" und verschiedene "PDFStructure"-Tabellen für die Generierung der PDF-Dateien benötigt (dazu später mehr in @pythonScript).

Jede Tabelle erhält eine Spalte "Id" als Primärschlüssel. @relationaleDb[Kapitel 3]  Über diese Id werden die Relationen zu anderen Tabellen ermöglicht. Zusätzlich wird für jede Eigenschaft aus @structure eine dazugehörige Spalte benötigt.



=== Überlegungen zur Übersetzbarkeit
Um die Anforderung @TRANSLATEMULTIPLE umsetzen zu können, wird eine Datenstruktur benötigt, welche die verschiedenen Texte in verschiedenen Sprachen aufbewahren kann. Hierzu wurden zunächst verschiedene Möglichkeiten evaluiert, um das beste Vorgehen zu ermitteln.

#heading(level: 4, outlined: false, numbering: none)[Idee 1]
Für die spätere Entwicklung des Frontends könnte es praktisch sein, alle Texte einer Art in einer eigenen Tabelle aufzubewahren (@idea1). Die Eingabe eines Textes könnte dann mit allen bisherigen Texten in der Tabelle abgeglichen werden, um Fehler zu finden. Für die erste Idee würde also pro Textfeld eine eigene Tabelle angelegt werden. Das Modul hätte beispielsweise für den Titel dann nur eine Id, die auf einen Eintrag in der Tabelle ModuleTitle verweist. ModuleTitle hätte dann einen Verweis auf TranslatedText. In TranslatedText könnten dann die konkreten Texte stehen.

Diese Methodik hat den Nachteil, dass pro Textfeld eine neue Tabelle benötigt wird. Dadurch kann die Datenstruktur schnell unübersichtlich werden. Außerdem könnte der Zugriff kompliziert sein. Für die Entwicklung dieses Systems sollte eine einfachere Lösung gesucht werden. 

#heading(level: 4, outlined: false, numbering: none)[Idee 2]
Eine etwas einfachere Methode wäre es, die übersetzten Texte in einer zentalen Tabelle "Translations" abzulegen (@idea2). Die Tabelle Modul hätte dann z. B. die Spalten TitleTranslationId, welche ein Foreign-Key auf die Tabelle Translation wäre. In Translation würde es dann die Spalten "Id", "English" und "German" geben, um die Texte dort abzuspeichern.

Für diese Lösung muss nur eine einzelne zusätzliche Tabelle erstellt werden, was den initialen Aufwand minimiert. Auch hat die zentrale Speicherung von Texten den Vorteil, dass diese sehr einfach verwaltet werden können. Bei der Einführung einer neuen Sprache müsste nur eine neue Spalte zur Tabelle hinzugefügt werden.

Die Lösung hat allerdings einen entscheidenen Nachteil. Ein Teilmodul hat 12 zu übersetzende Felder. Wenn dieses nun auf der Oberfläche angezeigt werden soll, muss für jedes der Felder ein Datenbank-Join, oder eine Unterabfrage gemacht werden. In der Tabelle Modul wird für jedes Textfeld nur eine Id abgelegt, die dann aus der Übersetzungstabelle abgerufen werden muss. Dies hätte einen hohen Aufwand im zukünftigen Quellcode der Anwendungen zu Folge.



#heading(level: 4, outlined: false, numbering: none)[Idee 3]
Um Zugriffe auf die Texte einfacher zu gestalten, wurde eine weitere Möglichkeit entwickelt (@idea3). Für jede Entität (z.B. Modul, Teilmodul...) wird neben der normalen Tabelle eine weitere Tabelle mit dem Suffix "\_Translations" angelegt. Diese Zusatztabelle enthält die übersetzten Textfelder. Für jede Sprache gibt es eine Zeile in der neuen Tabelle. Wenn es also zwei Sprachen gibt (Englisch & Deutsch) gibt es für jedes Modul zwei Einträge in der dazugehörigen Übersetzungstabelle.

Um nun ein Teilmodul mit 12 Feldern aus der Datenbank zu erhalten, wird mit dieser Lösung nur noch ein Join benötigt. Der Quellcode der zukünftigen Anwendung sollte dadurch deutlich besser wartbar sein.

#diagramFigure("ER-Diagramm - Idee 1", <idea1>, "ER_Translation")
#diagramFigure("ER-Diagramm - Idee 2", <idea2>, "idea1")
#diagramFigure("ER-Diagramm - Idee 3", <idea3>, "idea2")



=== Resultierendes Schema


In @ER ist ein kleiner Teil des entstandenen ER-Diagramms zu sehen. Die vollständige Version des Diagramms ist sehr groß und findet daher hier keinen Platz. Die vollständige Abbildung ist in der Dokumentation des Systems zu finden (Pfad: #link("https://studymodules-docs.tobi.win/docs/backend/Architecture/Database")[/docs/backend/Architecture/Database]). 

In dem Diagramm ist beispielsweise auf der linken Seite zu sehen, dass ein Modul immer einem Studiengang zugewiesen sein muss. Andersherum kann ein Studiengang 0 bis n verschiedene Module anbieten. Das Schema soll Entwickelnde dabei unterstützen, die Datenstruktur des Systems zu verstehen. Anhand des Schemas kann im folgenden Kapitel die Datenbank des Backends erstellt werden, sodass diese dann alle benötigten Daten abspeichern kann.
#diagramFigure("ER-Diagramm - Gesamtbild", <ER>, "simple_ER")




#block(breakable:false)[
== Benutzeroberflächen <UI>

Im Folgenden wird mithilfe von Mockups entworfen, wie die Benutzeroberflächen der neuen Anwendung aussehen sollen. Da an Mockups schnell Änderungen vorgenommen werden können, soll dieser Prozess dabei helfen, zeiteffizient gute Lösungen zu finden. Es werden zunächst in @scaffold die Elemente zur Navigation durch die Anwendung vorgestellt. Anschließend werden in @views die verschiedenen Komponenten der Anwendung, sowie die daraus zusammengesetzten Ansichten skizziert.
]

In den Mockups wird darauf geachtet, die von  #cite(<designInterfaces>, form: "prose") beschriebenen bekannten UI-Patterns anzuwenden. Dadurch sollen die Ansichten der neuen Anwendung selbsterklärend sein, da sie anderen modernen Websites ähneln. Weiterhin soll jede Ansicht, wenn möglich, genau einen Zweck verfolgen. Entweder soll eine Übersicht mehrere Elemente zeigen, oder ein einzelnes Element soll im Fokus stehen und detailliert gezeigt werden. Alternativ kann ein neues Element erstellt werden, oder eine Aufgabe soll erledigt werden. Das Mischen dieser Zuständigkeiten kann zu einer überladenen Website führen und wird deshalb, wenn möglich vermieden. @designInterfaces[Seite 35 ff.]



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
Die Oberfläche der Anwendung besteht aus einer oberen Leiste (Toolbar) und einer ausklappbaren Seitenleiste (Drawer). Unter der Toolbar ist die eigentliche Anwendung zu sehen, die aus verschiedenen Ansichten besteht. Die Toolbar ist in jeder Ansicht zu sehen. Diese Art der Navigation ist mittlerweile Standard und sollte für den Großteil der User selbsterklärend sein. @designInterfaces[Seite 131] 

#let toolbarText = [
  #heading(level: 4, numbering:none, "Toolbar")
Um mit möglichst wenig Aufwand (@CLICKS) jederzeit die Suchfunktion (@SEARCH) nutzen zu können, wird diese in der Toolbar platziert (siehe @grundgerüst). Neben der Suche ist ein Dropdown, mit dem die angezeigte Sprache umgestellt werden kann (@TRANSLATEMULTIPLE).  Damit jederzeit erkenntlich ist, in welcher Ansicht sich der User befindet (@PATH), wird diese Information als Breadcrumb auf der Toolbar platziert. @designInterfaces[Seite 193 f.]
]

#let toolbarImage = imageFigure(<grundgerüst>, "mockups/Grundgerüst.svg", "Toolbar")

#let boxedToolbarImage = box(toolbarImage, inset: 0.5em)

//#wrap-content(align: bottom + right,column-gutter: 1em,boxedToolbarImage, toolbarText)

#toolbarText
#toolbarImage


#let drawerText = [
  #heading(level: 4, numbering:none, "Drawer")
  Funktionen, die nicht oft benötigt werden, werden in einer ausklappbaren Seitenleiste (Drawer) platziert. Der Drawer kann mithilfe eines Knopfes ausgeklappt werden, welcher sich auf der Toolbar befindet. Somit können auch diese Funktionen mit wenig Aufwand (@CLICKS) von jeder Ansicht aus erreicht werden. Im Drawer sind die Masken zur Verwaltung der Benutzer (@CRUSER), zur Anzeige gelöschter Module (@SOFTDELETE) und zur Ansicht alter Prüfungsordnungen (siehe @drawer). Außerdem wird hier die Versionsnummer angezeigt, damit jederzeit überprüft werden kann, mit welcher Version des Systems gearbeitet wird.]


#let drawerImage = imageFigure(width: 40%,
  <drawer>, "mockups/Drawer.png", "Drawer")

//#wrap-content(align: bottom + right, drawerImage, drawerText)
#drawerText
#drawerImage



=== Komponenten und Ansichten <views>

#heading(level: 4, numbering:none, "Login")

#let loginText = [
Wenn ein User administrative Aufgaben übernehmen möchte, muss er sich zunächst über den Login-Button im Drawer (@drawer) anmelden (@LOGIN). Hierzu wird ein Screen benötigt, auf dem der User seine E-Mail und sein Passwort eingeben kann. Da Accounts von der studiengangsverantwortlichen Person erstellt werden (@CRUSER), wird auf dieser Seite keine Möglichkeit benötigt, sich selbst zu registrieren. Damit verständlich ist, wie ein Account erstellt werden kann, wird diese Information als Infotext unter dem Login-Button platziert (siehe @login).]
#let loginImage = imageFigure(<login>, "mockups/Login.png", "Login", width: 20em)


//#wrap-content(align: top + right, loginImage, loginText)

#loginText
#loginImage



#box[

#let searchFunctionImage = imageFigureNoPad(<search>, "mockups/Search.svg", "Suche mit Dropdown", width: 6.7em)

#let searchFunctionText = [
  #heading(level: 4, numbering:none, "Suchfunktion")
  Für die Suchfunktion wird eine Komponente benötigt, mit der ein bestimmtes Modul gefunden werden kann. In die Suchleiste soll der User den Namen des gesuchten Moduls eingeben können. Dabei muss der Modulname nicht vollständig eingegeben werden. Module, die zu dem eingegebenen Text passen, sollen vorgeschlagen werden. Durch die Vorschläge (siehe @search) spart der User Zeit, da nicht der vollständige Modulname eingegeben werden muss und auch nicht erst zu einer Ergebnisseite weitergeleitet wird. @designInterfaces[Seite 502 ff.] Der User kann einen Vorschlag anklicken, um sich dieses Modul anzusehen.

]

#let boxed = box(searchFunctionImage, inset: 0.5em)
#wrap-content(align: bottom + right, boxed, searchFunctionText)

]




  #heading(level: 4, numbering:none, "Navigation")

Auf der Startseite der neuen Anwendung soll nicht direkt die Modulübersicht präsentiert werden, weil diese ohne gesetzte Filter überladen wirken könnte. Stattdessen wird der User zunächst auf eine Übersicht aller Fakultäten geleitet (@navigationMockup). Hier kann entweder eine Fakultät ausgewählt werden, oder es kann per Klick auf "Alle Module" direkt zur Modulübersicht gewechselt werden. Die Farben der einzelnen Fakultäten sind dieselben wie auf der Website der #hsh @HochschuleHannover und sollen den User dabei unterstützen, schnell die richtige Fakultät zu finden. Diese Ansicht wird übersprungen, falls der User einen direkten Link zu einem bestimmten Studiengang aufruft. Dieser Link könnte beispielsweise auf der Website der Hochschule platziert sein. Der User wird dann direkt zur Modulübersicht geleitet.
  
#imageFigure(<navigationMockup>, "mockups/Navigation.png", "Startseite - Auswahl Fakultät")



Wenn in der Fakultätsauswahl eine Fakultät ausgewählt wurde, geht es weiter auf die Detailansicht der jeweiligen Fakultät (@navigationMockupLevel2). Hier werden alle Studiengänge der Fakultät aufgelistet. Die Studiengänge sind gruppiert nach der Abteilung, zu der sie zugehörig sind. Zur besseren Übersicht sind die Bachelorstudiengänge über den Masterstudiengängen angeordnet und zusätzlich farblich markiert. Des Weiteren gibt es die Möglichkeit in der oberen Leiste gezielt nach einem Studiengang zu suchen, oder nach Bachelor/Master zu filtern. Sobald auf dieser Übersicht ein Studiengang angeklickt wird, öffnet sich die Modulübersicht. In der Modulübersicht sind dann die Filter automatisch an die zuvor ausgewählte Fakultät und den ausgewählten Studiengang angepasst.

#imageFigure(<navigationMockupLevel2>, "mockups/NavigationLevel2.png", "Startseite - Auswahl Studiengang")



  
#pagebreak()
#heading(level: 4, numbering:none, "Modulübersicht")
#let moduleOverviewText = [
  In der Modulübersicht (@moduleoverview) sollen alle Module in einer tabellarischen Übersicht angezeigt werden. In der Tabelle sollen nur die für #link(<UseCaseInfoModule>)[Use Case 2] benötigten Daten gezeigt werden. Alle weiteren Informationen sind dann in der detaillierten Ansicht zu finden. Die detaillierte Ansicht soll sich durch Anklicken eines Eintrags öffnen. Über der Tabelle gibt es mehrere Filtermöglichkeiten, um die gesuchten Module schneller finden zu können.
]


#let moduleOverview = imageFigureNoPad(<moduleoverview>, "mockups/Modulübersicht.png", "Modulübersicht und Filter", width: 16em)

#wrap-content(align: bottom + right, moduleOverview, moduleOverviewText)
//#moduleOverviewText
//#moduleOverview



#heading(level: 4, numbering:none, "Detailansicht eines Modules")
Sobald ein Modul ausgewählt wurde, wird die Detailansicht eines Modules (@preview) präsentiert. Hier sollen die Details des Modules übersichtlich dargestellt werden. Einzelne Informationen können beispielsweise mithilfe eines Graphen oder anhand von Icons visualisiert werden. Hierdurch können Studierende oder studieninteressierte Personen innerhalb kurzer Zeit einen Eindruck erhalten, was die Rahmenbedingungen des Modules sind.


#imageFigure(<preview>, "modern-preview.png", "Detailansicht Modul")


#box[
  #heading(level: 4, numbering:none, "Modul anlegen / bearbeiten")

Angemeldete User sehen auf verschiedenen Seiten Buttons, mit denen sie Module anlegen und bearbeiten können. Damit die Dateneingabe für den User möglichst intuitiv ist, orientiert sich die Sortierung der Eingabefelder an der Sortierung der Felder im resultierenden PDF. Um eine einheitliche Optik zu erreichen wurden anschließend die Felder geringfügig umsortiert, sodass gleiche Datentypen, oder Felder, die thematisch zueinander passen, nah beieinander sind. Das resultierende PDF wird in der Vorschau imitiert. Hier werden die Eingaben des Users in Echtzeit angezeigt, sodass der User jederzeit sehen kann, wie die Modulbeschreibung aussehen wird.
  
#imageFigure(<addModule>, "mockups/AddModule.png", "Modul hinzufügen")
]

#let changeMessageText = [Damit in der Auflistung der Änderungen eine hilfreiche Nachricht steht, sollen die vorgenommenen Änderungen beim Speichern eines Moduls zusammengefasst werden. Hierzu fragt ein Pop-up nach der Zusammenfassung und erklärt dem User, wo dieser Text zu sehen sein wird (@changeMsgImg).]

#let changeMessageImg = imageFigureNoPad(<changeMsgImg>, "mockups/ÄnderungsMessage.png", "Text für Änderungshistorie", width: 12em)

#wrap-content(align: top + right, changeMessageImg, changeMessageText)

 
#let translateText = [
Für die Erstellung oder Bearbeitung eines Moduls kann entweder eine vorhandene Vorlage aus einem Dropdown ausgewählt werden (@lookup, @translateDropdown), oder ein neuer Text durch Klicken auf den "Neu"-Button angelegt werden. Dies ist besonders praktisch, da sich bestimmte Texte oft wiederholen. 

Wenn ein neuer Text angelegt wird, muss der User einen Kurztext angeben, der im Dropdown angezeigt wird, sowie die tatsächlichen Texte, die später im Modulhandbuch abgebildet werden (@translatePopup). 
]


#let translateDropdownImage = imageFigure(<translateDropdown>, "mockups/ÜbersetzbarkeitDropdown.svg", "Dropdown zur Textauswahl", width: 12em)







#translateText

#translateDropdownImage

#imageFigure(<translatePopup>, "mockups/Übersetzbarkeit.svg", "Neuen Text hinzufügen", width: 16em)





#block(breakable:false)[
#heading(level: 4, numbering:none, "Userverwaltung")

#let userText = [
  Das Hinzufügen eines neuen Users benötigt ebenfalls eine Eingabemaske (@createUser). Der Inhalt des Feldes "E-Mail-Adresse" wird automatisch anhand des eingegebenen Vor- und Nachnamens ausgefüllt, kann aber anschließend auch manuell bearbeitet werden, falls die E-Mail-Adresse vom bekannten Schema (vorname.nachname\@hs-hannover.de) einer Adresse der #hsh abweicht. Dies ist beispielsweise der Fall, wenn mehrere Personen denselben Vor- und Nachnamen haben.
]

#let userImage = imageFigureNoPad(<createUser>, "mockups/CreateUser.png", "Neuen User hinzufügen", width: 8em)

//#userText
//#userImage
#wrap-content(align: top + right, userImage, userText)
]

#box[
#heading(level: 4, numbering:none, "Änderungshistorie")

#let changeLogText = [
Alle Änderungen sollen nachverfolgbar sein (@SHOWCHANGES). Hierzu wird eine Übersicht über alle Änderungen benötigt (@changelogImage). Wenn eine Reihe der Tabelle, also eine einzelne Änderung angeklickt wird, öffnet sich eine Ansicht, in der die vorherige Version und die bearbeitete Version nebeneinander dargestellt sind. Mit einem Knopfdruck können die vorgenommenen Änderungen rückgängig gemacht werden. Auch hier wird nach einem Kommentar gefragt, um die Änderungen zusammenzufassen (@changeMsgImg)
]



#let changeLogImage = imageFigure(<changelogImage>, "mockups/Änderungshistorie.png", "Änderungshistorie", width: 24em)


#changeLogText
#changeLogImage
]



#box[
== Benötigte Endpunkte im Backend <endpoints>

Damit das zukünftige Frontend mit dem  Backend kommunizieren kann, muss das Backend Endpunkte (auch genannt Ressourcen, Endpoints, Routen...) bereitstellen, die das Frontend nutzen kann. Ein Endpunkt ist beispielsweise die Auflistung aller Module und ist mithilfe einer URI aufrufbar (hier z.B. /modules). Ein einzelnes Modul könnte über den Endpunkt #box[/modules/{id}] aufgerufen werden. @restUndHTTP[Abschnitt 3.2] 
]

In der vorliegenden Version des "StudyBase-"Backends gibt es bereits mehrere Endpunkte. Im Folgenden soll ermittelt werden, welche Endpunkte für das neue System benötigt werden. Nach dem YAGNI-Prinzip sollen dann in 
@implementierung nur die Endpunkte ausgearbeitet werden, die für das neue System benötigt werden. @restUndHTTP[Unterabschnitt 4.2.8] Durch die Planung, welche Endpunkte benötigt werden und wie diese aussehen sollen,  wird die spätere Implementierung in @createEndpoints beschleunigt, da dann dort weniger Entscheidungen getroffen werden müssen.

#heading(level: 4, numbering: none)[Endpunkt /modules]
Im zukünftigen Frontend sollen an verschiedenen Stellen die Module aufgelistet werden. Die Suchfunktion soll Vorschläge anhand der Modulliste machen, die Studiengänge sollen ihre Module anzeigen und die studiengangsverantwortliche Person soll alle Module verwalten können. Es wird also eine Ressource benötigt, die alle Module auflistet. Für die Suchfunktion muss die Ressource allerdings weniger Informationen anzeigen, als für die Detailansicht eines Moduls. Beispielsweise ist für die Suche zunächst uninteressant, was die angestrebten Lernergebnisse eines Moduls sind. Durch die Begrenzung der übersendeten Informationen müssen weniger Daten vom Backend ans Frontend gesendet werden. Dies trägt zu einer besseren Performance bei, weil weniger Daten über das Internet übertragen werden.


  Die Suchfunktion benötigt:
1. den Namen des Moduls, um einen Vorschlag anzuzeigen (@search)
2. die Id des Moduls, um die Detailansicht zu dem Modul öffnen zu können
3. den Studiengang des Moduls, um die Ergebnisse gruppieren zu können (@search)
Die Tabellen im restlichen System profitieren dahingegen von zusätzlichen Informationen. Diese können dabei helfen, die Module zu filtern (@FILTER), oder schnell Informationen zu einem Modul herauszufinden, ohne dieses aufrufen zu müssen. 

Es werden also die folgenden Informationen zusätzlich benötigt:
4. Semester, in dem das Modul vorgeschlagen ist (@recommendedSemester), um beispielsweise nur die Module des aktuellen Semesters zu filtern 
5. Credits, um nach Modulen filtern zu können, die einen bestimmten Aufwand haben
6. Gruppe, um beispielsweise ein interessantes Wahlpflichtfach zu finden
7. Ansprechpartner (@responsible), um schnell eine Kontaktinformation zu erhalten



Der Endpunkt /modules soll zusätzlich POST-Anfragen entgegennehmen können, um neue Module anzulegen. 


#heading(level: 4, numbering: none)[Endpunkt /modules/{id}]
  Hier sollten alle Informationen zur Verfügung gestellt werden, die für die Detailansichten eines einzelnen Moduls benötigt werden. Es müssen also alle Informationen aus @properties enthalten sein.

  Der Endpunkt /modules/{id} soll zusätzlich PUT-Anfragen entgegennehmen können, um bestehende Module bearbeiten zu können. 

#heading(level: 4, numbering: none)[Endpunkt /modules/{id}/changes]
  Hier sollten alle Informationen zur Verfügung gestellt werden, die für die Änderungshistorie eines Moduls benötigt werden (@changelogImage). Dazu gehört die Auflistung aller vorgenommenen Änderungen, der Autor der Änderung, sowie der erklärende Text, der bei einer Änderung angegeben werden muss (@changeMsgImg).

  
#heading(level: 4, numbering: none)[Endpunkt /submodules]
Ähnlich wie schon bei /modules wird eine Auflistung aller Teilmodule benötigt. Damit Teilmodule auffindbar sind, sollte die Auflistung den Namen des Teilmodules enthalten. Außerdem könnte die verantwortliche Person enthalten sein, damit Modulverantwortliche Personen nach den Teilmodulen filtern können, für die sie verantwortlich sind.
Der Endpunkt /submodules soll zusätzlich POST-Anfragen entgegennehmen können, um neue Teilmodule anzulegen. 

#heading(level: 4, numbering: none)[Endpunkt /submodules/{id}]
  Hier sollten alle Informationen zur Verfügung gestellt werden, die für die Detailansichten eines einzelnen Teilmoduls benötigt werden. Es müssen also alle Informationen aus @submoduleProps enthalten sein.

  Der Endpunkt /submodules/{id} soll zusätzlich PUT-Anfragen entgegennehmen können, um bestehende Teilmodule bearbeiten zu können. 

#heading(level: 4, numbering: none)[Endpunkt /group]
Für das Dropdown in dem die Gruppe eines Modules (@group) angegeben wird, wird ein eigener Endpunkt benötigt.  
Der Endpunkt /group soll zusätzlich POST-Anfragen entgegennehmen können, um neue Gruppen anzulegen.

#heading(level: 4, numbering: none)[Endpunkt /language]
Die Anwendung soll mehrere Sprachen unterstützen (@TRANSLATEMULTIPLE). Damit ein Wechsel der Sprache möglich ist, liefert dieser Endpunkt eine Liste der unterstützten Sprachen.



#heading(level: 4, numbering: none)[Endpunkt /autocomplete/{languageId}?type={type}]
Dieser Endpunkt soll alle verfügbaren Übersetzungen des angegebenen Typs zurückgeben. Ein Typ ist hier beispielsweise "EXAM_TYPE", für das Dropdown in dem die Prüfungsart angegeben wird (@exam). Mithilfe der Information sollen die verschiedenen Dropdowns in der Modulbearbeitung (@addModule), oder der Usererstellung (@createUser) befüllt werden.

#heading(level: 4, numbering: none)[Endpunkt /faculties]
Dieser Endpunkt ist für die Übersicht aller Fakultäten (@navigationMockup) zuständig. Hier ist es ausreichend, die Id der Fakultät sowie deren Namen bereitzustellen.

#heading(level: 4, numbering: none)[Endpunkt /faculty/{id}]
Für die Auswahl des Studiengangs (@navigationMockupLevel2) müssen alle Abteilungen der gewählten Fakultät geladen werden. Außerdem muss für jede Abteilung übermittelt werden, welche Studiengänge angeboten werden. Die Studiengänge müssen ein Feld enthalten, welches zwischen Bachelor- und Masterstudiengang unterscheidet, damit nach dieser Information gefiltert werden kann.

#heading(level: 4, numbering: none)[Endpunkt /department]
Dieser Endpunkt bietet eine Auflistung aller Abteilungen an. Zusätzlich sollten POST-Requests angenommen werden, um neue Abteilungen hinzufügen zu können.

#heading(level: 4, numbering: none)[Endpunkt /degrees]<degreesEndpoint>
Dieser Endpunkt bietet eine Auflistung aller Studiengänge an. Zusätzlich sollten POST-Requests angenommen werden, um neue Studiengänge hinzufügen zu können.

#heading(level: 4, numbering: none)[Endpunkt /auth/login]
Für den Login (@login) wird ein Endpunkt benötigt, der E-Mail und Passwort entgegennimmt, validiert und einen gültigen Token zurückgibt. Mithilfe des Tokens können die administrativen Funktionen genutzt werden, ohne sich jedes Mal mit E-Mail und Passwort autorisieren zu müssen. Dieser Endpunkt bestand bereits und wurde im Rahmen dieser Arbeit nicht verändert.

#heading(level: 4, numbering: none)[Endpunkt /job]
Für die PDF-Generierung wird ein Endpunkt benötigt, der eine Auflistung der Kompilierungsaufträge anbietet. Dieser Endpunkt muss POST-Anfragen annehmen, damit neue Aufträge angelegt werden können. Außerdem müssen PATCH-Anfragen angenommen werden, um den Status des Jobs zu verändern.





== Zwischenfazit
Im vergangenen Kapitel wurde das gesamte System geplant. Für das Backend gibt es ein Datenbankschema, sowie einen Plan, wie die Endpunkte der API gestaltet werden sollen. Für das Frontend gibt es Mockups für das Grundgerüst der Anwendung, sowie Mockups für einige Komponenten und Ansichten. Dank der detaillierten Planung sind im folgenden @implementierung weniger Entscheidungen zu treffen, sodass die Implementierung risikofreier ist.