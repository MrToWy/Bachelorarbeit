#import "../Template/customFunctions.typ": *

= Anforderungsanalyse <anforderungsanalyse>

Die Planung des neuen Systems für Modulhandbücher beginnt mit der Anforderungsanalyse. Der Schritt der Anforderungsanalyse hat eine besondere Wichtigkeit, da es mit fortlaufender Projektlaufzeit immer aufwändiger wird, Fehler zu korrigieren oder Anpassungen vorzunehmen. @kleuker_grundkurs_2013[Seite 55] Damit diese wichtige Phase gründlich absolviert wird, folgt der Ablauf der Anforderungsanalyse den Empfehlungen von Chris Rupp und den #sophisten @rupp_requirements-engineering_2014. Es werden zunächst der aktuelle Arbeitsprozess und die Architektur benachbarter Systeme analysiert und deren Probleme erkundet. Anschließend werden die Zielgruppen des neuen Systems ermittelt. Abschließend werden Ziele definiert.


== Architektur <architecture>
In der Abteilung Informatik der #hsh gibt es bereits mehrere Anwendungen, die ein gemeinsames Backend nutzen. Dieses Backend soll in dieser Arbeit erweitert werden, um auch den anderen Anwendungen die Auflistung der Modulhandbücher anbieten zu können. Zusätzlich wird eine neue Anwendung erstellt, die mit dem angepassten Backend kommunizieren wird.


=== Geplante Anwendungen <andereAnwendungen>

Für Studierende, die planen möchten, welches Modul sie in welchem Semester erledigen, wird es die Anwendung #studyPlan geben. Hier können Studierende vom vorgeschlagenen Studienverlauf abweichen und dabei sicherstellen, trotzdem alle Module in der gewünschten Zeit zu erledigen. #studyPlan wird von dem angepassten Backend profitieren, weil #studyPlan eine stets aktuelle Auflistung aller Module inklusive deren Zeitaufwände benötigt.

Die Entwicklung von #studyPlan läuft parallel zur Entwicklung dieser Bachelorarbeit – es muss also sichergestellt werden, dass es rechtzeitig nutzbare Ergebnisse gibt. Derzeit gibt es bereits einen ersten Prototyp, welcher allerdings noch nicht produktiv genutzt wird.

Außerdem ist die Anwendung StudyGraph geplant, welche Studieninhalte visualisiert und somit auch die Informationen zu den angebotenen Modulen benötigt.


=== Struktur des bestehenden Backends <backend>
Das bestehende Backend, auch #studybase genannt, ist mithilfe des auf JavaScript basierenden Framework #nest erstellt. #nest legt einen Fokus auf "effiziente, zuverlässige und skalierbare serverseitige Anwendungen" @nestjs.

Das #nest Backend ist modular aufgebaut.
Jede in @andereAnwendungen beschriebene Anwendung stellt im Backend ein Modul dar. Die Module der einzelnen Anwendungen enthalten ebenfalls Module, die die einzelnen Funktionen abbilden. Beispielsweise gibt es im Modul #studyPlan das Modul _degrees_, welches alle Studiengänge verwaltet.

Zusätzlich gibt es Module, die zwischen allen Anwendungen geteilt werden. Diese Shared-Modules bieten beispielsweise Funktionen zur Benutzerverwaltung und zum Versand von Emails an.

Damit Module Funktionalitäten anbieten können, nutzen sie verschiedene Konzepte. Damit ein Modul beispielsweise eine HTTP-GET-Anfrage bearbeiten kann, muss es eine #text(controller)-Klasse haben. Ein #controller nimmt die Anfrage an und verarbeitet sie. Falls hierbei Daten benötigt werden, ruft der #controller eine Service-Klasse auf. Diese lädt die angefragten Daten aus der Datenbank und gibt sie an den #controller zurück. Für die Datenbankzugriffe wird Prisma genutzt. 

#treeFigure(<backendFiles>, "Ordnerstruktur der StudyBase")[
  - StudyBase/src
    - Plan
      - Plan.Module
      - Degrees
        - Degree.Module
        - Degree.Controller
        - Degree.Service
    - Shared
      - Mailer
        - Mailer.Module
        - Mailer.Service
      - Prisma
        - Prisma.Module
        - Prisma.Service   
]

=== Struktur der bestehenden Datenbank <dbstructure>
Es gibt eine schema.prisma-Datei, in der die Struktur der relationalen Datenbank definiert ist. Somit muss kein SQL geschrieben werden, sondern es können Methoden von Prisma genutzt werden. Es gibt Tabellen für Module und Studiengänge. Die Tabellen werden von Prisma generiert. Änderungen an der Struktur müssen demnach an der schema.prisma-Datei erfolgen. Dadurch ist die Struktur der Datenbank versioniert und kann in einer Quellcodeverwaltung abgelegt werden.

#codeFigure("Auszug aus schema.prisma", <moduletable>, "moduleTablePrisma")


=== Struktur einer beispielhaften Angular Anwendung
Eine Angular Anwendung besteht aus Komponenten und Seiten. Auf einer Seite werden 0 bis n Komponenten in einer HTML-ähnlichen Struktur organisiert. 

Eine Komponente ist ein wiederverwendbares Element auf einer Website – beispielsweise ein Drop-Down, oder eine Textbox. Eine Komponente ist ebenfalls in der HTML-ähnlichen Struktur organisiert. In der Komponente können sich HTML-Elemente und andere Angular-Komponenten befinden.

Komponenten und Seiten haben eine .HTML-Datei für die Beschreibung der Struktur, eine .SCSS-Datei für die Beschreibung des Aussehens, sowie eine .TS-Datei für kleinere Logiken. Geschäftslogik wird meist in seperate #service#text("-Klassen") ausgelagert – ähnlich wie schon in @backend beschrieben. @angularStructure
  
== Interview mit Studiendekan <interview>
Da die Anforderungen sowie der aktuelle Arbeitsablauf noch unklar waren, musste eine Methode gefunden werden, um beides gründlich zu durchleuchten. Ein Interview hat den entscheidenden Vorteil, dass der Verlauf des Gesprächs individuell angepasst werden kann. Wenn sich neue Fragen ergeben, oder Fragen nicht ausreichend beantwortet wurden, kann im Interview direkt nachgefragt werden. @rupp_requirements-engineering_2014[Kapitel 6.3.3] 

Das Interview wurde mit dem derzeitigen Studiendekan #heine durchgeführt. Das Interview orientierte sich an den Vorschlägen der #sophisten. Bereits bei der Einladung zum Interview wurden einige der Vorschläge beachtet. Der Studiendekan konnte sich den Interviewort selbst auswählen und erhielt die geplanten Fragen vorab zur Einsicht. @rupp_requirements-engineering_2014[Seite 107-109]

Aus dem Interview ergaben sich zum einen die Konkretisierung der Zielgruppen in @zielgruppen. Zum Anderen wurde der aktuelle Arbeitsprozess klar definiert, sowie dessen Schwachstellen aufgezeigt (@oldProcess).

== Analyse des aktuellen Arbeitsprozesses und Identifikation von Schwachstellen <oldProcess>
Der Prozess um Modulhandbücher zu bearbeiten hat sich bereits in der Planungsphase dieser Arbeit verändert. Bisher hab es für die Modulhandbücher Word-Dokumente, welche in einem Git-Repository verwaltet wurden. Bei Änderungen mussten jeweils das deutsche und das englische Word Dokument bearbeitet werden. Anschließend kann es notwendig sein, die Änderungen auch im Curriculum des Studienganges (@mdiCurr) und im Anhang des besonderen Teils der Prüfungsordnung (@currTable) vorzunehmen.

Die kritischste Schwachstelle sind hier Redundanzen. Die Eigenschaften eines Modulhandbuches sind an mehreren verschiedenen Stellen hinterlegt und müssen überall von Hand angepasst werden. Bei dem manuellen Eintragen von Daten können schnell Fehler auftreten, da die verschiedenen Stellen nicht automatisch synchronisiert werden. @goll_entwurfsprinzipien_2018 

Als Vorbereitung für ein neues System wurden vom Studiendekan die zuvor genannten Word Dokumente maschinell eingelesen, in ein JSON-Format umgewandelt und anschließend in eine PostgresSQL-Datenbank eingespielt. Weiterhin wurde ein Python Script erstellt, welches aus den Datensätzen in der Datenbank mithilfe von LaTeX ein PDF-Dokument für die Modulhandbücher generieren kann. Die Datenbank enthält jedoch weiterhin Redundanzen und ist nicht vollständig normalisiert. 



== Zielgruppen <zielgruppen>
Im folgenden Abschnitt sollen die verschiedenen Zielgruppen eines Modulhandbuches ermittelt und definiert werden. Die Übersicht der Zielgruppen wird für die später folgende Ermittlung der Use Cases benötigt (@usecases). Hierdurch wird ermöglicht zu verstehen, wer das Modulhandbuch verwenden wird und welche Anforderungen die verschiedenen Gruppen haben. Zur Ermittlung wurde zum einen im ECTS User-Guides @ects recherchiert und zum anderen das Interview (@interview) genutzt.


=== Studieninteressierte
Der ECTS User-Guide @ects beschreibt, dass Modulhandbücher bereits bei der Wahl eines Studiengangs helfen können. So können Personen die an einem bestimmten Studiengang interessiert sind, mithilfe der Beschreibungen in den Modulhandbüchern herausfinden, welche Inhalte gelehrt werden. Modulhandbücher sind demnach eine gute Anlaufstelle um einen ersten Eindruck zu den angebotenen Modulen eines Studienganges zu erhalten.


=== Studierende
Eine weitere Zielgruppe sind Studierende. Diese können mithilfe der Modulbeschreibungen verstehen, welche Inhalte in einem Modul gelernt werden und welche Voraussetzungen es gibt. Dadurch können Studierende einschätzen, ob sie genug Vorwissen für ein bestimmtes Modul haben. Weiterhin können Studierende dank der Modulhandbücher zu jedem Modul den korrekten Ansprechpartner finden, einen Überblick über die zu erbringende Arbeitszeit erhalten, sowie Informationen zu den Prüfungsleistungen finden. 





=== Modulverantwortliche und Studiengangverantwortliche
Aus dem Interview mit dem Studiendekan (@interview) geht hervor, dass es neben den Studierenden noch andere zu betrachtende Zielgruppen gibt. Für die Bearbeitung von Modulhandbüchern sind an der #hsh verschiedene Personengruppen zuständig. Zum einen gibt es den Studiengangverantwortlichen. Dieser ist für die Veröffentlichung des Dokumentes verantwortlich. Der Studiengangverantwortliche ist nicht dafür zuständig, die Inhalte der einzelnen Modulbeschreibungen anzupassen. Für diese Anpassungen gibt es die Modulverantwortlichen. Jedes Modul hat eine Person, die die Informationen der Modulbeschreibung aktuell halten soll und gleichzeitig Ansprechpartner für Fragen ist. In der Abteilung Informatik ist aktuell der Studiendekan gleichzeitig auch Studiengangverantwortlicher. Modulverantwortliche sind die Professoren und Dozierenden der Abteilung.


== Use Cases <usecases>
Im folgenden Abschnitt werden die Ergebnisse aus den Interviews und der Recherche im ECTS User Guide @ects verwendet, um aufzuzeigen, welche Funktionen die einzelnen Akteure im neuen System verwenden können.@rupp_requirements-engineering_2014[Seite~192] Hierzu werden Use Cases bestimmt, damit im nächsten Abschnitt (@requirements) daraus Anforderungen abgeleitet werden können. So soll sichergestellt werden, dass alle zuvor bestimmten Akteure ihre Aufgaben vollständig mit dem neuen System erledigen können.



/*
  "Sie können Use-Case-Beschreibungen als Ergänzung zu Use-Case-Diagrammen erstellen, etwa um jeden einzelnen Use-Case aus dem Diagramm genauer zu beleuchten. Use-Case Beschreibungen können aber auch ohne Diagramm für sich stehen."
*/

#include("Planung/use-cases.typ")


== Anforderungen <requirements>
Die Anforderungen an das System ergeben sich aus verschiedenen Quellen, die sich in die Kategorien funktional und nichtfunktional aufteilen lassen.
Um die Herkunft der Anforderungen übersichtlich abzubilden, werden die Anforderungen in Funktional und Nicht-Funktional aufgeteilt. 

Jede Anforderung in den folgenden Auflistungen enthält entweder das Wort "muss", "sollte", oder "könnte". @rupp_requirements-engineering_2014[Kapitel 1.5.2] Damit wird zwischen Anforderungen unterschieden, die zwingend erforderlich sind (muss), Anforderungen, die sehr sinnvoll sind (sollte) und Anforderungen, die nicht zwingend erforderlich sind, aber die Nutzer begeistern würden (könnte). Eine weitere Priorisierung wird an dieser Stelle nicht benötigt, sondern kann bei Bedarf erfolgen.

#import "@preview/gentle-clues:0.7.1": *



#block(breakable: false)[
=== Funtionale Anforderungen
#task(title:[Aus #link(<UseCaseSearch>)[Use-Case 1] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Studiengänge ansehen", type: "F", label: <SHOWCOURSES>)[Nicht angemeldete Person (NP) muss Studiengänge ansehen können.]
  #narrowTrack("Curriculum anzeigen", type: "F", label: <CURR>)[NP könnte sich das Curriculum eines Studienganges anzeigen lassen.]
  #narrowTrack("Suchfunktion", type: "F", label: <SEARCH>)[NP sollte Suche nutzen können, um einen Studiengang zu finden.]
  #narrowTrack("Pdf anzeigen", type: "F", label: <PDF>)[NP sollte ein PDF mit allen Modulbeschreibungen ansehen können.]
]
]

#task(title: [Aus #link(<UseCaseFilter>)[Use-Case 2] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Module ansehen", type: "F", label: <SHOWMODULES>)[NP muss Module ansehen können.]
  #narrowTrack("Filterfunktion", type: "F", label: <FILTER>)[NP sollte Filter nutzen können, um das gesuchte Modul zu finden.]
]


#task(title: [Aus #link(<UseCaseEditModule>)[Use-Case 3] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Login", type: "F", label: <LOGIN>)[Ein User muss sich anmelden können.]
  #narrowTrack("Module bearbeiten", type: "F", label: <EDIT>)[Modulverantwortliche Person muss Module bearbeiten können, für die Sie als Ansprechpartner hinterlegt ist.]
  #narrowTrack("Plausibilitätschecks bei Modulen", type: "F", label: <CHECKMOD>)[System sollte Änderungen an Modulen auf Plausibilität prüfen.]
]

#task(title: [Aus #link(<UseCaseCreateUser>)[Use-Case 4] ergeben sich folgende Anforderungen:])[
  #narrowTrack("User anlegen", type: "F", label: <CRUSER>)[Studiengangsverantwortliche Person (SVP) muss neue User anlegen können.]
  #narrowTrack("Plausibilitätschecks bei Usern", type: "F", label: <CHECKUS>)[System sollte Änderungen an Usern auf Plausibilität prüfen.]
]

#task(title: [Aus #link(<UseCaseCreateModule>)[Use-Case 5] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Module verwalten", type: "F", label: <MODULE>)[SVP muss Module verwalten (anlegen, bearbeiten, löschen) können.]
  #narrowTrack("Module duplizieren", type: "F", label: <DUPLICATE>)[SVP sollte Module duplizieren können.]
  #narrowTrack("Studiengänge verwalten", type: "F", label: <COURSE>)[SVP muss Studiengänge verwalten können.]
]

#task(title: [Aus #link(<UCRevertChanges>)[Use-Case 6] ergibt sich folgende Anforderung:])[
  #narrowTrack("Änderungen anzeigen", type: "F", label: <SHOWCHANGES>)[SVP sollte sich einzelne Änderungen an einem Modul anzeigen lassen können.]
  #narrowTrack("Änderungen widerrufen", type: "F", label: <REVERT>)[SVP könnte einzelne Änderungen an einem Modul rückgängig machen.]
]

#task(title: [Aus #link(<UseCaseTable>)[Use-Case 7] ergibt sich folgende Anforderung:])[
  #narrowTrack("Anhang der Prüfungsordnung", type: "F", label: <COMPARE>)[SVP könnte sich die Auflistung aller Module als Tabelle anzeigen lassen, um sie mit dem Anhang der Prüfungsordnung vergleichen zu können.]
]

#task(title: [Dadurch, dass die administrativen Bereiche nur ausgewählten Benutzern zur Verfügung stehen sollen, entstehen die folgenden Anforderungen:])[
  #narrowTrack("Logout", type: "F", label: <LOGOUT>)[Ein User sollte sich ausloggen können.]
#narrowTrack("Passwörter zurücksetzen", type: "F", label: <RESETPW>)[SVP muss Passwörter zurücksetzen können.]
#narrowTrack("Eigenes Passwort zurücksetzen", type: "F", label: <RESETMYPW>)[SVP sollte das eigene Passwort zurücksetzen können.]
]


#block(breakable: false)[
=== Nicht-Funtionale Anforderungen
Die Nicht-Funktionalen Anforderungen ergeben sich aus einem Brainstorming unter der Berücksichtigung der ISO-Norm ISO/IEC 25000 @rupp_requirements-engineering_2014[Kapitel 12] und ergeben sich aus den Bedingungen aus @architecture.

#linebreak()

Die ISO-Norm 25000 beschreibt verschiedene Merkmale, die zur Messung von Softwarequalität genutzt werden können. Um eine gute Softwarequalität zu erreichen, sollten aus allen Merkmalen konkrete Anforderungen an das neue System abgeleitet werden. Die Merkmale sind jeweils in Submerkmale unterteilt. Nicht jedes Submerkmal ist für das neue System relevant, jedoch sollten möglichst viele Submerkmale in Anforderungen übersetzt werden, um eine gute Qualität sicherzustellen.

Das Merkmal #emph("Änderbarkeit") besteht aus den Submerkmalen #emph("Analysierbarkeit"), #emph("Modifizierbarkeit"), #emph("Stabilität") und #emph("Testbarkeit").

#task(title: [Änderbarkeit])[

  #narrowTrack("Modularität", type:"N", label: <MODULAR>)[
  Der Quellcode des Systems sollte aus Komponenten bestehen.
]

  #narrowTrack("Wiederverwendbarkeit", type:"N", label: <TESTABLE>)[
  Einzelne Komponenten sollten wiederverwendbar sein.
]

  #narrowTrack("Eine Verantwortlichkeit", type:"N", label: <Verantwortlichkeit>)[
  Die Komponenten sollten genau eine Verantwortlichkeit haben.
]

  #narrowTrack("Testbarkeit", type:"N", label: <TESTABLE>)[
  Die Komponenten sollten gut testbar sein.
]

#narrowTrack("Unittests", type:"N", label:<TEST>)[
  Geschäftslogik könnte mithilfe von Unittests automatisiert getestet werden.
]

#narrowTrack("e2e-Tests", type:"N", label:<TESTUI>)[
  System könnte mithilfe von e2e-Tests automatisiert getestet werden.
]
]
]

Das Merkmal #emph("Benutzbarkeit") besteht aus den Submerkmalen #emph("Verständlichkeit"), #emph("Erlernbarkeit"), #emph("Bedienbarkeit"), #emph("Attraktivität") und #emph("Konformität").

#task(title: [Benutzbarkeit])[
  #narrowTrack("Aktueller Pfad", type:"N", label: <PATH>)[
  System könnte anzeigen, welcher Pfad aufgerufen wurde \ (z.B. Fakultät->Studiengang->Modul).
]

  
#narrowTrack("Rückfragen", type:"N", label:<ASK>)[
  Vor dem Löschen eines Elements muss eine Rückfrage erscheinen.
]

#narrowTrack("Wiederherstellbarkeit", type:"N", label:<SOFTDELETE>)[
  Gelöschte Elemente könnten wiederherstellbar sein.
]

#narrowTrack("Ladebalken", type:"N", label:<QUICK>)[
  Ladezeiten >1s sollten einen Ladebalken zeigen.
]

#narrowTrack("Verständlichkeit", type:"N", label:<ERROR>)[
  Fehlermeldungen sollten verständlich sein.
]

#narrowTrack("Lösung anbieten", type:"N", label:<ERRORSOLVE>)[
  Fehlermeldungen könnten eine Lösung anbieten.
]

#narrowTrack("Responsive", type:"N", label:<RESPONSIVE>)[
  Das System könnte auf verschiedenen Displaygrößen nutzbar sein.
]

#narrowTrack("Eingabemethoden", type:"N", label:<KEYBOARD>)[
  Das System könnte verschiedene Eingabemethoden unterstützen.
]

#narrowTrack("Selbsterklärend", type:"N", label:<SELFEXPLAIN>)[
  Das System sollte selbsterklärend sein und kein Handbuch benötigen.
]
]

Das Merkmal #emph("Effizienz") besteht aus den Submerkmalen #emph("Zeitverhalten"), #emph("Verbrauchsverhalten") und #emph("Konformität").

#task(title: [Effizienz])[
  
  #narrowTrack("Startzeit Frontend", type:"N", label:<STARTFRONTEND>)[
  Jede Seite im Frontend sollte innerhalb einer Sekunde geladen sein.
]

#narrowTrack("Startzeit Backend", type:"N", label:<STARTBACKEND>)[
  Das Backend sollte im kritischen Fehlerfall innerhalb einer Minute neustarten.
]

  #narrowTrack("Deployment", type:"N", label:<DEPLOY>)[
  Das Deployment könnte automatisiert sein.
]

  #narrowTrack("Effizienz der Aufgabenerledigung", type:"N", label:<CLICKS>)[
  Jeder Use-Case sollte mit möglichst wenigen Klicks erledigbar sein.
]
]

Das Merkmal #emph("Funktionalität") besteht aus den Submerkmalen #emph("Angemessenheit"), #emph("Richtigkeit"), #emph("Interoperabilität"), #emph("Sicherheit") und #emph("Ordnungsmäßigkeit").

#task(title: [Funktionalität])[
  #narrowTrack("Zwei Sprachen", type:"N", label:<TRANSLATE>)[
  Das System muss in Englisch und Deutsch verfügbar sein.
]

#narrowTrack("Mehrsprachenfähigkeit", type:"N", label:<TRANSLATEMULTIPLE>)[
  Das System sollte für beliebig viele Sprachen erweiterbar sein.
]

#narrowTrack("Auswahlmöglichkeiten", type:"N", label: <lookup>)[
  System sollte möglichst oft vorschlagen, welche Eingaben sinnvoll wären.
]


]

Das Merkmal #emph("Übertragbarkeit") besteht aus den Submerkmalen #emph("Anpassbarkeit"), #emph("Installierbarkeit"), #emph("Koexistenz"), #emph("Austauschbarkeit") und #emph("Konformität").

#task(title: [Übertragbarkeit])[
  #narrowTrack("Dokumentation zur Installation", type:"N", label: <DOKBACK>)[
  Es sollte dokumentiert sein, wie das System installiert wird.
]
]

Das Merkmal #emph("Zuverlässigkeit") besteht aus den Submerkmalen #emph("Reife"), #emph("Fehlertoleranz"), #emph("Robustheit"), #emph("Wiederherstellbarkeit") und #emph("Konformität").

#task(title: [Zuverlässigkeit])[
  #narrowTrack("Stabilität", type:"N", label: <ERRORSTABLE>)[
  Das System muss bei auftretenden Fehlern weiterhin funktionieren / sich selbst wiederherstellen.
]
]

#task(title: [Technische Anforderungen (ergeben sich aus @architecture)])[
  #narrowTrack("Neue Anwendung", type:"N", label: <FRONT>)[
  Das Frontend muss eine neue Anwendung sein.
]

#narrowTrack("Technologien im Frontend", type:"N", label: <FRONT_TECH>)[
  Das Frontend muss Angular nutzen.
]

#narrowTrack("Bestehende Anwendung", type:"N", label: <BACK>)[
  Das bestehende Backend muss erweitert werden.
]

#narrowTrack("Technologien im Backend", type:"N", label: <BACK_TECH>)[
  Das Backend muss Primsa und NestJS nutzen.
]

#narrowTrack("Bestehende Datenbank", type:"N", label: <DB>)[
  Die bestehende Datenbank muss erweitert werden.
]
]

#task(title: [Weitere Anforderungen])[
  #narrowTrack("Dokumentation im Backend", type:"N", label: <DOKBACK>)[
  Neue API-Endpoints sollten dokumentiert sein.
]
#narrowTrack("Normalisierte Datenbank", type:"N", label: <normalized>)[
  Die Datenbank sollte in der dritten Normalform sein.
]
]












/*
@rupp_requirements-engineering_2014[Kapitel 5.3]


sollte / muss als Schlüsselwörter


qualitätskriterien für anforderungen
@rupp_requirements-engineering_2014[Kapitel 1.8.1]
@rupp_requirements-engineering_2014[Kapitel 5.3]

#image("../Images/image.png")


Tab. 5.1 Leitfragen zur Erstellung hoch-qualitativer Anforderungen
@broy_einfuhrung_2021[s.~209]

Kontextgrenzen
@rupp_requirements-engineering_2014[Kapitel 5.4.2]

6.2

  
#image("../Images/Faktoren.png")
Basisfaktoren
Wenn Ihnen das Fachgebiet geläufig ist, kennen Sie diese in vielen Fällen selbst und könnten sie selbst ergänzen.

Auf diese Leistungsfaktoren stoßen Sie zuerst, da die Stakeholder sie explizit nennen. Sie können also mittels Befragungstechniken ermittelt werden.

Beigeisterungsfaktoren
Brainstorming
Risiko, der Machbarkeit, Nützlichkeit und dem Begeisterungspotenzial.


*/



== Struktur eines Modulhandbuches <structure>
Die Modulhandbücher der Abteilung Informatik haben für alle drei Studiengänge (BIN, MDI und MIN) dieselbe Struktur. Es gibt eine Aufteilung in Module und Teilmodule. Ein Modul kann dabei 0 bis n verschiedene Teilmodule haben und jedes Teilmodul kann zu 1 bis n Modulen gehören. Teilmodule können Studiengangsübergreifend mit Modulen verknüpft werden. #emph("Beispiel"): Es gibt das Modul "MDI-103 Grundlagen der Informatik" und das Modul "BIN-103 Grundlagen der Informatik". Beide verweisen auf das Teilmodul "BIN-103-01 Grundlagen der Informatik". Somit können Studiengangsübergreifende Module abgebildet werden. In der Regel hat jedoch jedes Modul genau ein Teilmodul und umgekehrt gehört in der Regel jedes Teilmodul zu genau einem Modul.

=== Moduleigenschaften <properties>
Das Modul enthält zunächst grundlegende Informationen:

#track("Titel", example: "BIN-100 Mathematik 1")[
  Zusammengesetzt aus einem Kürzel des Studiengangs,  einer eindeutigen Zahl und dem Namen des Moduls.
]

#track("Untertitel", example: "Mathematische Grundlagen der Informatik (BIN-MAT1) oder C/C++ (BIN-PR3)")[
  Ein alternativer, ggf. etwas präziserer Name des Moduls, sowie ein Kürzel. In den aktuell veröffentlichten Handbüchern ist hier oft nur das Kürzel angegeben.
]

#track("Modulniveau")[
  Hier ist angegeben, ob das Modul ein Grundlagenmodul oder Vertiefungsmodul ist. 
]

#track("Pflicht / Wahlpflicht")[
  Hier ist angegeben, ob das Modul ein Pflichtmodul oder Wahlpflichtmodul ist.
  Studierende müssen alle Pflichtmodule absolvieren und müssen eine bestimmte Anzahl an selbst ausgewählten Wahlpflichtmodulen absolvieren.
]

#track("Teilmodule")[
  Eine Auflistung aller Teilmodule.
]

#track("Verantwortliche(r)", example: "Wohlfeil, Stefan, Prof. Dr.", label: <responsible>)[
  Name der verantwortlichen Person. Diese Person ist für die Bearbeitung des Modulhandbuches zuständig.
]

#track("Credits")[
  Anzahl erreichbarer ECTS bei Absolvierung dieses Moduls. Eine Zahl zwischen 2 (Englisch) und 30 (z.B. Masterarbeit).
]

#track("Präsenzstunden / Selbststudium", example: "68 h / 112 h")[
  Aufwand des Studiums, aufgeteilt nach der Zeit, die in der Hochschule verbracht wird und der Zeit, die im Selbststudium verbracht wird (Arbeit an Übungen, Prüfungsvorbereitung …).
]

#track("Studiensemester", label: <recommendedSemester>)[
  Vorgeschlagenes Semester. Anhand dieser Information wird das Curriculum generiert (@mdiCurr). 
]

#track("Moduldauer", example: "1 Semester")[
  Hier ist angegeben, wie lange es dauert das Modul zu absolvieren.
]

#track("Voraussetzungen nach Prüfungsordnung", example: "Alle Modulprüfungen des 1. bis 3. Semesters")[
  Für die Absolvierung des Moduls zwingend erforderliche Voraussetzungen.
]

#track("Empfohlene Voraussetzungen", example: "Alle Module der Semester 1 bis 3 sowie BIN-112 und BIN-202")[
  Für die Absolvierung des Moduls empfohlene Voraussetzungen.
]

#track("Studien-/ Prüfungsleistungen", example: "Referat (Hausarbeit plus Präsentation/Vortrag), Anwesenheitspflicht", label:<exam>)[
  Eine kommagetrennte Auflistung der zu erbringenden Leistungen.
]

#track("Angestrebte Lernergebnisse", example: "Die Studierenden sind in der Lage, dreidimensionale Objekte zu gestalten, zu bewegen und zueinander in Beziehung zu setzen.", label:<erg>)[
  Eine stichpunktartige, kommagetrennte Auflistung der Kompetenzen, die in diesem Modul erworben werden.
]

#text(" ")<EndOfChapter>

=== Teilmoduleigenschaften
Die Teilmodule enthalten zusätzlich weitere Informationen:

#context [
  #for (value) in (range(counter(heading).at(<EndOfChapter>).last())) {
  counter(heading).step(level: 9)
}
]

#track("Titel", example: "BIN-100-01 Mathematik 1")[
  Der Titel des Teilmoduls setzt sich zusammen aus dem Kürzel des übergeordneten Moduls, einer eigenen Nummer und dem Namen des Teilmoduls.
]

#track("Sprache", example: ["nach Vereinbarung" oder "deutsch"])[
  Hier ist angegeben, in welcher Sprache die Veranstaltung stattfindet.
]

#track("Zuordnung zu Curricula", example: "BIN, MDI")[
  Eine kommagetrennte Auflistung aller Studiengänge, in denen dieses Teilmodul verwendet wird.
]

#track("Veranstaltungsart, SWS", example: "Vorlesung mit Übung, 4 SWS")[
  Eine Kurzbeschreibung zum Ablauf der Veranstaltung, sowie deren Dauer in Semesterwochenstunden.
]

#track("Empfehlungen zum Selbststudium", example: "Aufbereitung der Lehrveranstaltung anhand von eigenen Projekten")[
  Hier stehen Vorschläge, wie der Lehrinhalt im Selbststudium vertieft werden kann.
]

#track("Gruppengröße")[
  Üblicherweise eine Zahl zwischen 1 (Bachelorarbeit) und 100 (Mathematik 1).
]

#track("Inhalt", example: "Neue und aktuelle Trends im Bereich Betriebssysteme und Netze")[
  Die Inhalte der Veranstaltung kurz zusammengefasst.
]

#track("Anforderungen der Präsenzzeit", example: "Regelmäßige und aktive Teilnahme.")[
  Hier ist kurz beschrieben, was von Studierenden in der Präsenzzeit erwartet wird.
]

#track("Anforderungen des Selbststudiums", example: "Vor- und Nachbereitung")[
  Hier ist kurz beschrieben, was von Studierenden außerhalb der Präsenzzeit erwartet wird.
]

#track("Literatur", example: "Skript zur Vorlesung
Reges, S., Stepp, M.: Building Java Programs, Prentice Hall")[
  Eine Auflistung empfohlener Literatur zur Vertiefung des behandelten Themas.
]