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


#todo(inline:true)[
  hier müssen die Überlegungen zur Übersetzbarkeit hin

  Idee, alle Übersetzungen in eine Tabelle zu legen und in den einzelnen Tabellen dann nur Key-Ids zu speichern
]

Um die Anforderung @TRANSLATEMULTIPLE vorzubereiten, wurde die Tabelle TranslatedText für alle Eigenschaften mit dem Datentyp "TEXT" genutzt. Zur besseren Lesbarkeit wurde dies nur exemplarisch für die Eigenschaften E1-E3 dargestellt:

#diagramFigure("ER-Diagramm - TranslatedText", <ER_TRANS>, "ER_Translation")



== Benutzeroberflächen <UI>

Im Folgenden wird mithilfe von Mockups entworfen, wie die Benutzeroberflächen der neuen Anwendung aussehen sollen. Da an Mockups schnell Änderungen vorgenommen werden können, soll dieser Prozess dabei helfen, zeiteffizient gute Lösungen zu finden. Es werden zunächst in @scaffold die Elemente zur Navigation durch die Anwendung vorgestellt. Anschließend werden in @views die verschiedenen Komponenten der Anwendung, sowie die daraus zusammengesetzten Ansichten skizziert.

In den Mockups wird darauf geachtet, die von  #cite(<designInterfaces>, form: "prose") beschriebenen bekannten UI-Patterns anzuwenden. Dadurch sollen die Ansichten der neuen Anwendung selbsterklärend sein, da sie anderen modernen Websites ähneln. Weiterhin soll jede Ansicht wenn möglich genau einen Zweck verfolgen – entweder soll eine Übersicht mehrere Elemente zeigen, oder ein einzelnes Element soll im Fokus stehen und detailliert gezeigt werden, oder ein neues Element soll erstellt werden, oder eine Aufgabe soll erledigt werden. Das Mischen dieser Zuständigkeiten kann zu einer überladenen Website führen und wird deshalb wenn möglich vermieden. @designInterfaces[Seite 35 ff.]



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
Die Oberfläche der Anwendung besteht aus einer oberen Leiste (Toolbar) und einem ausklappbaren Drawer. Unter der Toolbar ist die eigentliche Anwendung zu sehen, die aus verschiedenen Ansichten besteht. Die Toolbar ist in jeder Ansicht zu sehen. Diese Art der Navigation ist mittlerweile Standard und sollte für den Großteil der User selbsterklärend sein. @designInterfaces[Seite 131] 

#let toolbarText = [
  #heading(level: 4, numbering:none, "Toolbar")
Um mit möglichst wenig Aufwand (@CLICKS) jederzeit die Suchfunktion (@SEARCH) nutzen zu können, wird diese in der Toolbar platziert. Neben der Suche ist ein Dropdown, mit dem die angezeigte Sprache umgestellt werden kann (@TRANSLATEMULTIPLE).  Damit jederzeit erkenntlich ist, in welcher Ansicht sich der User befindet (@PATH), wird diese Information als Breadcrumb auf der Toolbar platziert. @designInterfaces[Seite 193 f.]
]

#let toolbarImage = imageFigureNoPad(<grundgerüst>, "mockups/Grundgerüst.svg", "Toolbar")

#let boxedToolbarImage = box(toolbarImage, inset: 0.5em)

#wrap-content(align: bottom + right,
column-gutter: 1em,
boxedToolbarImage, toolbarText)



#let drawerText = [
  #heading(level: 4, numbering:none, "Drawer")
  Funktionen, die nicht oft benötigt werden, werden in einer ausklappbaren Seitenleiste (Drawer) platziert. Die Seitenleiste kann mithilfe eines Knopfes ausgeklappt werden, welcher sich auf der Toolbar befindet. Somit können auch diese Funktionen mit wenig Aufwand (@CLICKS) von jeder Ansicht aus erreicht werden. Im Drawer sind die Masken zur Verwaltung der Benutzer (@CRUSER), zur Anzeige gelöschter Module (@SOFTDELETE) und zur Ansicht alter Prüfungsordnungen. Außerdem wird hier die Versionsnummer angezeigt, damit jederzeit überprüft werden kann, mit welcher Version des Systems gearbeitet wird.]


#let drawerImage = imageFigureNoPad(width: 40%,
  <drawer>, "mockups/Drawer.png", "Drawer")

#wrap-content(align: bottom + right, drawerImage, drawerText)
//#drawerText
//#drawerImage


#box[
=== Komponenten und Ansichten <views>

#heading(level: 4, numbering:none, "Login")

#let loginText = [
Wenn ein User administrative Aufgaben übernehmen möchte, muss er sich zunächst über den Login-Button im Drawer (@drawer) anmelden (@LOGIN). Hierzu wird ein Screen benötigt, auf dem der User seine Email und sein Passwort eingeben kann. Da Accounts von der studiengangsverantwortlichen Person erstellt werden (@CRUSER), wird auf dieser Seite keine Möglichkeit benötigt, sich selbst zu registrieren. Damit verständlich ist, wie ein Account erstellt werden kann, wird diese Information als Infotext unter dem Login-Button platziert.]
#let loginImage = imageFigureNoPad(<login>, "mockups/Login.png", "Login", width: 20em)


#wrap-content(align: top + right, loginImage, loginText)
]

#box[

#let searchFunctionImage = imageFigureNoPad(<search>, "mockups/Search.png", "Suche mit Dropdown", width: 6em)

#let searchFunctionText = [
  #heading(level: 4, numbering:none, "Suchfunktion")
  Für die Suchfunktion wird eine Komponente benötigt, mit der ein bestimmtes Modul gefunden werden kann. In die Suchleiste soll der User den Namen des gesuchten Modules eingeben können. Dabei muss der Modulname nicht vollständig eingegeben werden. Module, die zu dem eingebenen Text passen, sollen vorgeschlagen werden. Durch die Vorschläge spart der User Zeit, da nicht der vollständige Modulname eingegeben werden muss und auch nicht erst zu einer Ergebnisseite weitergeleitet wird. @designInterfaces[Seite 502 ff.] Der User kann einen Vorschlag anklicken, um sich dieses Modul anzusehen.

]

#let boxed = box(searchFunctionImage, inset: 0.5em)
#wrap-content(align: bottom + right, boxed, searchFunctionText)

]


#heading(level: 4, numbering:none, "Modulübersicht")
#let moduleOverviewText = [
  In der Modulübersicht sollen alle Module in einer tabellarischen Übersicht angezeigt werden. In der Tabelle sollen nur die für #link(<UseCaseFilter>)[Use-Case 2] benötigten Daten gezeigt werden. Alle weiteren Informationen sind dann in der detaillierten Ansicht zu finden. Die detaillierte Ansicht soll sich durch Anklicken eines Eintrags öffnen. Über der Tabelle gibt es mehrere Filtermöglichkeiten, um die gesuchten Module schneller finden zu können.
]


#let moduleOverview = imageFigureNoPad(<moduleoverview>, "mockups/Modulübersicht.png", "Modulübersicht und Filter", width: 16em)

#wrap-content(align: bottom + right, moduleOverview, moduleOverviewText)
//#moduleOverviewText
//#moduleOverview

#box[
  #heading(level: 4, numbering:none, "Navigation")

Auf der Startseite der neuen Anwendung soll nicht direkt die zuvor vorgestellte Modulübersicht präsentiert werden, weil diese ohne gesetzte Filter überladen wirken könnte. Stattdessen wird der User zunächst auf eine Übersicht aller Fakultäten geleitet (@navigationMockup). Hier kann entweder eine Fakultät ausgewählt werden, oder es kann per Klick auf "Alle Module" direkt zur Modulübersicht gewechselt werden. Die Farben der einzelnen Fakultäten sind dieselben wie auf der Website der #hsh @HochschuleHannover und sollen den User dabei unterstützen, schnell die richtige Fakultät zu finden.
  
#imageFigureNoPad(<navigationMockup>, "mockups/Navigation.png", "Startseite - Auswahl Fakultät")
]

#box[
Wenn in der Fakultätsauswahl eine Fakultät ausgewählt wurde, geht es weiter auf die Detailansicht der jeweiligen Fakultät (@navigationMockupLevel2). Hier werden alle Studiengänge der Fakultät aufgelistet. Die Studiengänge sind gruppiert nach der Abteilung, zu der sie zugehörig sind. Zur besseren Übersicht sind die Bachelorstudiengänge über den Masterstudiengängen angeordnet und zusätzlich farblich markiert. Des weiteren gibt es die Möglichkeit in der oberen Leiste gezielt nach einem Studiengang zu suchen, oder nach Bachelor/Master zu filtern. Sobald auf dieser Übersicht ein Studiengang angeklickt wird, öffnet sich die Modulübersicht. In der Modulübersicht sind dann die Filter automatisch an die zuvor ausgewählte Fakultät und den ausgewählten Studiengang angepasst.

#imageFigureNoPad(<navigationMockupLevel2>, "mockups/NavigationLevel2.png", "Startseite - Auswahl Studiengang")
]


#box[
  #heading(level: 4, numbering:none, "Modul anlegen / bearbeiten")

Angemeldete User sehen auf verschiedenen Seiten Buttons, mit denen sie Module anlegen und bearbeiten können. Damit die Dateneingabe für den User möglichst intuitiv ist, orientiert sich die Sortierung der Eingabefelder an der Sortierung der Felder im resultierenden PDF. Um eine einheitliche Optik zu erreichen wurden anschließend die Felder geringfügig umsortiert, sodass gleiche Datentypen, oder Felder die thematisch zueinander passen, nah beieinander sind. Das resultierende PDF wird in der Vorschau imitiert. Hier werden die Eingaben des Users in Echtzeit angezeigt, sodass der User jederzeit sehen kann, wie die Modulbeschreibung aussehen wird.
  
#imageFigureNoPad(<addModule>, "mockups/AddModule.png", "Modul hinzufügen")
]

#let changeMessageText = [Damit in der Auflistung der Änderungen eine hilfreiche Nachricht steht, sollen die vorgenommenen Änderungen beim Speichern eines Moduls zusammengefasst werden. Hierzu fragt ein Popup nach der Zusammenfassung und erklärt dem User kurz wo dieser Text zu sehen sein wird.]

#let changeMessageImg = imageFigureNoPad(<changeMsgImg>, "mockups/ÄnderungsMessage.png", "Text für Änderungshistorie", width: 12em)

#wrap-content(align: top + right, changeMessageImg, changeMessageText)

 
#let translateText = [
Für die Erstellung oder Bearbeitung eines Moduls kann entweder ein vorhandener Text aus einem Dropdown ausgewählt werden (@lookup), oder ein neuer Text durch klicken auf den "Neu"-Button angelegt werden. Dies ist besonders praktisch, da sich bestimmte Texte oft wiederholen. 

Wenn ein neuer Text angelegt wird, muss der User einen Kurztext angeben, der im Dropdown angezeigt wird, sowie die tatsächlichen Texte, die später im Modulhandbuch abgebildet werden. 
]


#let translateDropdownImage = imageFigureNoPad(<translateDropdown>, "mockups/ÜbersetzbarkeitDropdown.svg", "Dropdown zur Textauswahl", width: 12em)

#let translateImage = imageFigureNoPad(<translatePopup>, "mockups/Übersetzbarkeit.svg", "Neuen Text hinzufügen", width: 12em)

#let translationBoxed = box(inset: 0.4em)[#translateDropdownImage #translateImage]

#wrap-content(align: top + right, translationBoxed, translateText)

//#translateText
//#translateDropdownImage
//#translateImage

#heading(level: 4, numbering:none, "Userverwaltung")

#let userText = [
  Das Hinzufügen eines neuen Users benötigt wenige Eingaben. Der Inhalt des Feldes "E-Mail Adresse" wird automatisch anhand des eingegebenen Vor- und Nachnames ausgefüllt, kann aber anschließend auch manuell bearbeitet werden, falls die E-Mail Adresse vom bekannten Schema (vorname.nachname\@hs-hannover.de) einer Adresse der #hsh abweicht. Dies ist beispielsweise der Fall, wenn mehrere Personen den selben Vor- und Nachnamen haben.
]

#let userImage = imageFigureNoPad(<createUser>, "mockups/CreateUser.png", "Neuen User hinzufügen", width: 8em)

//#userText
//#userImage
#wrap-content(align: top + right, userImage, userText)

#box[
#heading(level: 4, numbering:none, "Änderungshistorie")

#let changeLogText = [
Alle Änderungen sollen nachverfolgbar sein (@SHOWCHANGES). Hierzu wird eine Übersicht über alle Änderungen benötigt. Wenn eine Reihe der Tabelle, also eine einzelne Änderung angeklickt wird, öffnet sich eine Ansicht, in der die vorherige Version und die bearbeitete Version nebeneinander dargestellt sind. Mit einem Knopfdruck können die vorgenommenen Änderungen rückgängig gemacht werden. Auch hier wird nach einem Kommentar gefragt, um die Änderungen zusammenzufassen (@changeMsgImg)
]



#let changeLogImage = imageFigureNoPad(<changelogImage>, "mockups/Änderungshistorie.png", "Änderungshistorie", width: 16em)


#wrap-content(align: top + right, changeLogImage, changeLogText)
]

#imageFigure(<preview>, "modern-preview.png", "")

#box[
== Benötigte Endpunkte im Backend <endpoints>

Damit das zukünftige Frontend mit dem  Backend kommunizieren kann, muss das Backend Endpunkte (auch genannt Ressourcen, Endpoints, Routen...) bereitstellen, die das Frontent nutzen kann. Ein Endpunkt ist beispielsweise die Auflistung aller Module und ist mithilfe einer URI aufrufbar (hier z.B. /modules). Ein einzelnes Modul könnte über den Endpunkt #box[/modules/{id}] aufgerufen werden. @restUndHTTP[Abschnitt 3.2] 
]

In der vorliegenden Version des "StudyBase-"Backends gibt es bereits mehrere Endpunkte. Im Folgenden soll ermittelt werden, welche Endpunkte für das neue System benötigt werden. Nach dem YAGNI-Prinzip sollen dann in 
@implementierung nur die Endpunkte ausgearbeitet werden, die für das neue System benötigt werden. @restUndHTTP[Unterabschnitt 4.2.8] Durch die Planung, welche Endpunkte benötigt werden und wie diese aussehen sollen,  wird die spätere Implementierung in @createEndpoints beschleunigt, da dann dort weniger Entscheidungen getroffen werden müssen.

#heading(level: 4, numbering: none)[Endpunkt /modules]
Im zukünftigen Frontend sollen an verschiedenen Stellen die Module aufgelistet werden. Die Suchfunktion soll Vorschläge anhand der Modulliste machen, die Studiengänge sollen ihre Module anzeigen und die studiengangsverantwortliche Person soll alle Module verwalten können. Es wird also eine Resource benötigt, die alle Module auflistet. Für die Suchfunktion muss die Resource allerdings weniger Informationen anzeigen, als für die Detailansicht eines Moduls. Beispielsweise ist für die Suche zunächst uninteressant, was die angestrebten Lernergebnisse eines Modules sind. Durch die Begrenzung der übersendeten Informationen, müssen weniger Daten vom Backend ans Frontend gesendet werden. Dies trägt zu einer besseren Performance bei, weil weniger Daten über das Internet übertragen werden.


  Die Suchfunktion benötigt:
1. den Namen des Moduls, um einen Vorschlag anzuzeigen (@search)
2. die Id des Moduls, um die Detailansicht zu dem Modul öffnen zu können
3. den Studiengang des Moduls, um die Ergebnisse gruppieren zu können (@search)
Die Tabellen im restlichen System profitieren dahingegen von zusätzlichen Informationen. Diese können dabei helfen, die Module zu filtern (@FILTER), oder schnell Informationen zu einem Modul herauszufinden, ohne dieses aufrufen zu müssen. 

Es werden also die folgenden Informationen zusätzlich benötigt:
4. Semester, in dem das Modul vorgeschlagen ist (@recommendedSemester), um beispielsweise nur die Module des aktuellen Semester zu filtern 
5. Ansprechpartner (@responsible), um schnell eine Kontaktinformation zu erhalten


Der Endpunkt /modules soll zusätzlich POST-Anfragen entgegen nehmen können, um neue Module anzulegen. 


#heading(level: 4, numbering: none)[Endpunkt /modules/{id}]
  Hier sollten alle Informationen zur Verfügung gestellt werden, die für die Detailansichten eines einzelnen Moduls benötigt werden. Es müssen also alle Informationen aus @properties enthalten sein.

  Der Endpunkt /modules/{id} soll zusätzlich PUT-Anfragen entgegen nehmen können, um bestehende Module bearbeiten zu können. 

#heading(level: 4, numbering: none)[Endpunkt /modules/{id}/changes]
  Hier sollten alle Informationen zur Verfügung gestellt werden, die für die Änderungshistorie eines Moduls benötigt werden (@changelogImage). Dazu gehört die Auflistung aller vorgenommenen Änderungen, der Autor der Änderung, sowie der erklärende Text, der bei einer Änderung angegeben werden muss (@changeMsgImg).
  
#heading(level: 4, numbering: none)[Endpunkt /translations/{type}]
Dieser Endpunkt soll alle verfügbaren Übersetzungen des angegebenen Typs zurückgeben. Ein Typ ist hier beispielsweise "EXAM_TYPE", für das Dropdown in dem die Prüfungsart angegeben wird (@exam). Mithilfe der Information sollen die verschiedenen Dropdowns in der Modulbearbeitung (@addModule), oder der Usererstellung (@createUser) befüllt werden.

#heading(level: 4, numbering: none)[Endpunkt /faculties]
Dieser Endpunkt ist für die Übersicht aller Fakultäten (@navigationMockup) zuständig. Hier ist es ausreichend, die Id der Fakultät sowie deren Namen bereitzustellen.

#heading(level: 4, numbering: none)[Endpunkt /faculty/{id}]
Für die Auswahl des Studiengangs (@navigationMockupLevel2) müssen alle Abteilungen der gewählten Fakultät geladen werden. Außerdem muss für jede Abteilung übermittelt werden, welche Studiengänge angeboten werden. Die Studiengänge müssen ein Feld enthalten, welches zwischen Bachelor- und Masterstudiengang unterscheidet, damit nach dieser Information gefiltert werden kann.

#heading(level: 4, numbering: none)[Endpunkt /user/login]
Für den Login (@login) wird ein Endpunkt benötigt, der E-Mail und Passwort entgegennimmt, validiert und einen gültigen Token zurückgibt. Mithilfe des Tokens können die administrativen Funktionen genutzt werden, ohne sich jedes Mal mit E-Mail und Passwort autorisieren zu müssen.


== Zwischenfazit
Im vergangenen Kapitel wurde das gesamte System geplant. Für das Backend gibt es ein Datenbankschema, sowie einen Plan, wie die Endpunkte der API gestaltet werden sollen. Für das Frontend gibt es Mockups für das Grundgerüst der Anwendung, sowie Mockups für einige Komponenten und Ansichten. Dank der detaillierten Planung sind im folgenden @implementierung weniger Entscheidungen zu treffen, sodass die Implementierung risikofreier ist.