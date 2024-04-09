#import "../Template/customFunctions.typ": *

= Anforderungsanalyse <anforderungsanalyse>

Die Planung des neuen Systems für Modulhandbücher beginnt mit der Anforderungsanalyse. Der Schritt der Anforderungsanalyse hat eine besondere Wichtigkeit, da es mit fortlaufender Projektlaufzeit immer aufwändiger wird, Fehler zu korrigieren oder Anpassungen vorzunehmen. @kleuker_grundkurs_2013[Seite 55] Damit diese wichtige Phase gründlich absolviert wird, folgt der Ablauf der Anforderungsanalyse den Empfehlungen von Chris Rupp und den #sophisten @rupp_requirements-engineering_2014. Es werden zunächst der aktuelle Arbeitsprozess und die Architektur benachbarter Systeme analysiert und deren Probleme erkundet. Anschließend werden die Zielgruppen des neuen Systems ermittelt. Abschließend werden Ziele definiert.


== Architektur <architecture>
In der Abteilung Informatik der #hsh gibt es bereits mehrere Anwendungen, die ein gemeinsames Backend nutzen. Dieses Backend soll in dieser Arbeit erweitert werden, um auch den anderen Anwendungen die Auflistung der Modulhandbücher anbieten zu können. Zusätzlich wird eine neue Anwendung erstellt, die mit dem angepassten Backend kommunizieren wird.


=== Bestehende Anwendungen <andereAnwendungen>

Für Studierende, die planen möchten, welches Modul sie in welchem Semester erledigen, gibt es die Anwendung #studyPlan. Hier können Studierende vom vorgeschlagenen Studienverlauf abweichen und dabei sicherstellen, trotzdem alle Module in der gewünschten Zeit zu erledigen. #studyPlan wird von dem angepassten Backend profitieren, weil #studyPlan eine stets aktuelle Auflistung aller Module inklusive deren Zeitaufwände benötigt.

Die Entwicklung von #studyPlan läuft parallel zur Entwicklung dieser Bachelorarbeit – es muss also sichergestellt werden, dass es rechtzeitig nutzbare Ergebnisse gibt.

Außerdem gibt es die Anwendung StudyGraph, welche Studieninhalte visualisiert und somit auch die Informationen zu den angebotenen Modulen benötigt.


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

=== Struktur der bestehenden Datenbank
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
Im Folgenden sollen die verschiedenen Zielgruppen eines Modulhandbuches ermittelt und definiert werden.


=== Studieninteressierte
Der ECTS User-Guide @ects beschreibt, dass Modulhandbücher bereits bei der Wahl eines Studiengangs helfen können. So können Personen die an einem bestimmten Studiengang interessiert sind, mithilfe der Beschreibungen in den Modulhandbüchern herausfinden, welche Inhalte gelehrt werden. Modulhandbücher sind demnach eine gute Anlaufstelle um einen ersten Eindruck zu den angebotenen Modulen eines Studienganges zu erhalten.


=== Studierende
Eine Weitere Zielgruppe sind Studierende. Diese können mithilfe der Modulbeschreibungen verstehen, welche Inhalte in einem Modul gelernt werden und welche Voraussetzungen es gibt. Dadurch können Studierende einschätzen, ob sie genug Vorwissen für ein bestimmtes Modul haben. Weiterhin können Studierende dank der Modulhandbücher zu jedem Modul den korrekten Ansprechpartner finden, einen Überblick über die zu erbringende Arbeitszeit erhalten, sowie Informationen zu den Prüfungsleistungen finden. 





=== Modulverantwortliche und Studiengangverantwortliche
Aus dem Interview mit dem Studiendekan (@interview) geht hervor, dass es neben den Studierenden noch andere zu betrachtende Zielgruppen gibt. Für die Bearbeitung von Modulhandbüchern sind an der #hsh verschiedene Personengruppen zuständig. Zum einen gibt es den Studiengangverantwortlichen. Dieser ist für die Veröffentlichung des Dokumentes verantwortlich. Der Studiengangverantwortliche ist nicht dafür zuständig, die Inhalte der einzelnen Modulbeschreibungen anzupassen. Für diese Anpassungen gibt es die Modulverantwortlichen. Jedes Modul hat eine Person, die die Informationen der Modulbeschreibung aktuell halten soll und gleichzeitig Ansprechpartner für Fragen ist. In der Abteilung Informatik ist aktuell der Studiendekan gleichzeitig auch Studiengangverantwortlicher. Modulverantwortliche sind die Professoren und Dozierenden der Abteilung.


== Use Cases <usecases>
Die Ergebnisse aus den vorherigen Abschnitten werden mithilfe der Use–Case–Modellierung verwendet, um aufzuzeigen, welche Funktionen die einzelnen Akteure im neuen System verwenden können.@rupp_requirements-engineering_2014[Seite~192]

/*
  "Sie können Use-Case-Beschreibungen als Ergänzung zu Use-Case-Diagrammen erstellen, etwa um jeden einzelnen Use-Case aus dem Diagramm genauer zu beleuchten. Use-Case Beschreibungen können aber auch ohne Diagramm für sich stehen."
*/

#useCase(1)[
  Studiengang per Suche finden 
][
  Studieninteressierte Person
][
  Fakultät ausgewählt
][
  1. User gibt "MDI" in das Suchfeld ein
  2. System zeigt den Studiengang Mediendesigninformatik an
  3. User klickt den Eintrag an
  4. System zeigt den Studiengang und dessen Module
  5. User klickt auf "PDF anzeigen" und sieht alle Modulbeschreibungen in einem PDF
]<UseCaseSearch>

#useCase(2)[
  Modul per Filter finden
][
  Studierende Person
][
  Studiengang ausgewählt
][
  1. User wählt in den Filteroptionen als Semester 2 aus
  2. System zeigt alle Module an, die laut Curriculum im 2. Semester empfohlen werden
  3. User klickt einen Eintrag an
  4. System zeigt das Modul
]<UseCaseFilter>


#useCase(3)[
  Informationen zu einem Modul verändern
][
  Modulverantwortliche Person
][
  Erfolgreich mit einem Account eingeloggt, der das ausgewählte Modul bearbeiten darf
][
  1. User drückt auf "Bearbeiten"
  2. System wechselt in den Bearbeitungsmodus
  3. User aktualisiert Texte in den Eingabefeldern
  4. User drückt auf "Speichern"
  5. System prüft, ob Änderungen plausibel sind (z. B. passen Zeitaufwände und ECTS zusammen)
  6. System wechselt in den Anzeigemodus
]<UseCaseEditModule>


#useCase(4)[
  Eine neue Modulverantwortliche Person anlegen
][
  Studiengangsverantwortliche Person
][
  Erfolgreich mit einem Account eingeloggt, der Modulverantwortliche Personen anlegen darf
][
  1. User drückt auf Accountübersicht
  2. User drückt auf "Hinzufügen"
  3. System wechselt in den Bearbeitungsmodus
  4. User füllt Eingabefelder 
  5. User drückt auf "Speichern"
  6. System prüft, ob Angaben plausibel sind (z.B. passt Name zu Email)
  7. System zeigt "Account erfolgreich angelegt"
]<UseCaseCreateUser>


#useCase(5)[
  Ein neues Modul anlegen
][
  Studiengangsverantwortliche Person
][
  Erfolgreich mit einem Account eingeloggt, der Module anlegen darf
][
  1. User drückt auf Module
  2. User drückt auf "Hinzufügen"
  3. System wechselt in den Bearbeitungsmodus
  4. User füllt Eingabefelder 
  5. User drückt auf "Speichern"
  6. System prüft, ob Angaben plausibel sind (z.B. passen Zeitaufwände und ECTS zusammen)
  7. System zeigt "Account erfolgreich angelegt"
]<UseCaseCreateModule>

#useCase(6)[
  Tabelle im Anhang der Prüfungsordnung überprüfen
][
  Studiengangsverantwortliche Person
][
  Alle Module des Studiengangs angelegt
][
  1. User erstellt die Tabelle manuell
  2. User öffnet die generierte Tabelle im System
  3. User vergleicht beide Tabellen, um sicherzustellen dass sie korrekt sind
]<UseCaseTable>


== Anforderungen 
Zur besseren Übersichtlichkeit werden die Anforderungen in Funktional und Nicht-Funktional aufgeteilt. 

Jede Anforderung in den folgenden Auflistungen enthält entweder das Wort "muss", "sollte", oder "könnte". @rupp_requirements-engineering_2014[Kapitel 1.5.2] Damit wird zwischen Anforderungen unterschieden, die zwingend erforderlich sind (muss), Anforderungen, die sehr sinnvoll sind (sollte) und Anforderungen, die nicht zwingend erforderlich sind, aber die Nutzer begeistern würden (könnte). Eine weitere Priorisierung wird an dieser Stelle nicht benötigt, sondern kann bei Bedarf erfolgen.


=== Funtionale Anforderungen

#import "@preview/gentle-clues:0.7.1": *

#task(title:[Aus #link(<UseCaseSearch>)[Use-Case 1] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Studiengänge ansehen", type: "F")[Nicht angemeldete Person (NP) muss Studiengänge ansehen können.]<SHOWCOURSES>
  #narrowTrack("Curriculum anzeigen", type: "F")[NP könnte sich das Curriculum eines Studienganges anzeigen lassen.]<CURR>
  #narrowTrack("Suchfunktion", type: "F")[NP sollte Suche nutzen können, um den gesuchten Studiengang zu finden.]<SEARCH>
  #narrowTrack("PDF anzeigen", type: "F")[NP sollte ein PDF mit allen Modulbeschreibungen runterladen können.]<PDF>
]

#task(title: [Aus #link(<UseCaseFilter>)[Use-Case 2] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Module ansehen", type: "F")[NP muss Module ansehen können.]<SHOWMODULES>
  #narrowTrack("Filterfunktion", type: "F")[NP sollte Filter nutzen können, um das gesuchte Modul zu finden.]<FILTER>
]


#task(title: [Aus #link(<UseCaseEditModule>)[Use-Case 3] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Login", type: "F")[Ein User muss sich einloggen können.]<LOGIN>
  #narrowTrack("Module bearbeiten", type: "F")[Modulverantwortliche Person muss Module bearbeiten können, für die Sie als Ansprechpartner hinterlegt ist.]<EDIT>
  #narrowTrack("Plausibilitätschecks bei Modulen", type: "F")[System sollte Änderungen an Modulen auf Plausibilität prüfen.]<CHECKMOD>
]

#task(title: [Aus #link(<UseCaseCreateUser>)[Use-Case 4] ergeben sich folgende Anforderungen:])[
  #narrowTrack("User anlegen", type: "F")[Studiengangsverantwortliche Person (SVP) muss neue User anlegen können]<CRUSER>
  #narrowTrack("Plausibilitätschecks bei Usern", type: "F")[System sollte Änderungen an Usern auf Plausibilität prüfen.]<CHECKUS>
]

#task(title: [Aus #link(<UseCaseCreateModule>)[Use-Case 5] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Module verwalten", type: "F")[SVP muss Module verwalten können.]<MODULE>
  #narrowTrack("Module duplizieren", type: "F")[SVP sollte Module duplizieren können.]<DUPLICATE>
  #narrowTrack("Studiengänge verwalten", type: "F")[SVP muss Studiengänge verwalten (anlegen, verändern, löschen) können.]<COURSE>
  #narrowTrack("Änderungen anzeigen", type: "F")[SVP sollte sich einzelne Änderungen anzeigen lassen können.]<SHOWCHANGES>
  #narrowTrack("Änderungen widerrufen", type: "F")[SVP könnte einzelne Änderungen rückgängig machen.]<REVERT>
]

#task(title: [Aus #link(<UseCaseTable>)[Use-Case 6] ergibt sich folgende Anforderung:])[
  #narrowTrack("Anhang der Prüfungsordnung", type: "F")[SVP könnte sich die Auflistung aller Module als Tabelle anzeigen lassen, um sie mit dem Anhang der Prüfungsordnung vergleichen zu können.]<COMPARE>
]

#task(title: [Dadurch, dass die administrativen Bereiche nur ausgewählten Benutzern zur Verfügung stehen sollen, entstehen die folgenden Anforderungen:])[
  #narrowTrack("Logout", type: "F")[Ein User sollte sich ausloggen können.]<LOGOUT>
#narrowTrack("Passwörter zurücksetzen", type: "F")[SVP muss Passwörter zurücksetzen können.]<RESETPW>
#narrowTrack("Eigenes Passwort zurücksetzen", type: "F")[SVP sollte das eigene Passwort zurücksetzen können.]<RESETMYPW>
]


=== Nicht-Funtionale Anforderungen
Die Nicht-Funktionalen Anforderungen ergeben sich aus einem Brainstorming unter der Berücksichtigung der Iso-Norm #todo("Iso Norm eintragen und zusammenfassen", inline:true) und ergeben sich aus den Bedingungen aus @architecture.

#narrowTrack("Aktueller Pfad", type:"N")[
  System könnte anzeigen, welcher Pfad aufgerufen wurde (Fakultät->Studiengang->Modul)
]<PATH>

#narrowTrack("Rückfragen", type:"N")[
  Vor dem Löschen eines Elements muss eine Rückfrage erscheinen
]<ASK>

#narrowTrack("Wiederherstellbarkeit", type:"N")[
  Gelöschte Elemente könnten wiederherstellbar sein
]<SOFTDELETE>

#narrowTrack("Ladebalken", type:"N")[
  Ladezeiten >500ms sollten einen Ladebalken zeigen
]<QUICK>

#narrowTrack("Dokumentation im Backend", type:"N")[
  Neue API-Endpoints sollten dokumentiert sein
]<DOKBACK>

#narrowTrack("Unittests", type:"N")[
  Geschäftslogik könnte mithilfe von Unittests automatisiert getestet werden
]<TEST>

#narrowTrack("e2e-Tests", type:"N")[
  System könnte mithilfe von e2e-Tests automatisiert getestet werden
]<TESTUI>

#narrowTrack("Deployment", type:"N")[
  Das Deployment könnte automatisiert sein
]<DEPLOY>

#narrowTrack("Modularität", type:"N")[
  Einzelne Komponenten des Quellcodes sollten wiederverwendbar sein 
]<MODULAR>

#narrowTrack("Verständlichkeit", type:"N")[
  Fehlermeldungen sollten verständlich sein
]<ERROR>

#narrowTrack("Lösung anbieten", type:"N")[
  Fehlermeldungen könnten eine Lösung anbieten
]<ERRORSOLVE>

#narrowTrack("Stabilität", type:"N")[
  Das System muss bei auftretenden Fehlern weiterhin funktionieren / sich selbst wiederherstellen
]<ERRORSTABLE>

#narrowTrack("Zwei Sprachen", type:"N")[
  Das System muss in Englisch und Deutsch verfügbar sein
]<TRANSLATE>

#narrowTrack("Beliebig viele Sprachen", type:"N")[
  Das System sollte für beliebig viele Sprachen erweiterbar sein
]<TRANSLATEMULTIPLE>

#narrowTrack("Responsive", type:"N")[
  Das System könnte auf verschiedenen Displaygrößen nutzbar sein
]<RESPONSIVE>

#narrowTrack("Eingabemethoden", type:"N")[
  Das System könnte verschiedene Eingabemethoden unterstützen
]<KEYBOARD>

#narrowTrack("Neue Anwendung", type:"N")[
  Das Frontend muss eine neue Anwendung sein
]<FRONT>

#narrowTrack("Angular im Frontend", type:"N")[
  Das Frontend muss Angular nutzen
]<FRONT_TECH>

#narrowTrack("Aktuelles Backend beibehalten", type:"N")[
  Das bestehende Backend muss erweitert werden
]<BACK>

#narrowTrack("Prisma und NestJS im Backend", type:"N")[
  Das Backend muss Primsa und NestJS nutzen
]<BACK_TECH>

#narrowTrack("Aktuelle Datenbank beibehalten", type:"N")[
  Die bestehende Datenbank muss erweitert werden
]<DB>



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

