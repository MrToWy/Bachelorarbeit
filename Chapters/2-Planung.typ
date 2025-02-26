#import "../Template/customFunctions.typ": *

= Anforderungsanalyse <anforderungsanalyse>

Die Planung des neuen Systems für Modulhandbücher beginnt mit der Anforderungsanalyse. Der Schritt der Anforderungsanalyse hat eine besondere Wichtigkeit, da es mit fortlaufender Projektlaufzeit immer aufwändiger wird, Fehler zu korrigieren oder Anpassungen vorzunehmen. @kleuker_grundkurs_2013[Seite 55] Damit diese wichtige Phase gründlich absolviert wird, folgt der Ablauf der Anforderungsanalyse den Empfehlungen von Chris Rupp und den #sophisten @rupp_requirements-engineering_2014. Es wird zunächst in @architecture die Umgebung des Systems erkundet. Anschließend wird mithilfe eines Interviews (@interview) der aktuelle Arbeitsprozess analysiert (@oldProcess) und dessen Probleme erkundet. Dann werden die Zielgruppen des neuen Systems ermittelt (@zielgruppen). Aus den Zielgruppen ergeben sich Use Cases (@usecases) und dazugehörige Anforderungen (@requirements). Zuletzt wird in @structure die Struktur eines Modulhandbuches untersucht.


== Systemumgebung <architecture>
In diesem Abschnitt soll zunächst die Umgebung des neuen Systems ermittelt werden. Hierzu werden die bestehenden Anwendungen untersucht. Das neue System soll dieselben Technologien wie die bestehenden Anwendungen verwenden. Dies hat den Vorteil, dass ein Entwickler nach Einarbeitung in die Technologien alle Anwendungen weiterentwickeln kann. Damit die Anforderungen an das neue System klar definiert werden können, muss also zunächst die Umgebung untersucht werden.


In der Abteilung Informatik der #hsh gibt es bereits mehrere Anwendungen, die ein gemeinsames Backend nutzen. Dieses Backend soll in dieser Arbeit erweitert werden, um auch den anderen Anwendungen die Auflistung der Modulhandbücher anbieten zu können. Zusätzlich wird eine neue Anwendung erstellt, die mit dem angepassten Backend kommunizieren wird.


=== Geplante Anwendungen <andereAnwendungen>
Zusätzlich zur Entwicklung dieses Projektes gibt es noch zwei weitere Anwendungen, die jedoch kein Teil dieser Arbeit sind. Im Folgenden werden die geplanten Anwendungen kurz erklärt.

Für Studierende, die planen möchten, welches Modul sie in welchem Semester erledigen, wird es die Anwendung #studyPlan geben. Hier können Studierende vom vorgeschlagenen Studienverlauf abweichen und dabei sicherstellen, trotzdem alle Module in der gewünschten Zeit zu erledigen. #studyPlan wird von dem angepassten Backend profitieren, weil #studyPlan eine stets aktuelle Auflistung aller Module inklusive deren Zeitaufwände benötigt, um die Planung des Studienverlaufs zu ermöglichen.

Die Entwicklung von #studyPlan läuft parallel zur Entwicklung dieser Bachelorarbeit – es muss also sichergestellt werden, dass es rechtzeitig nutzbare Ergebnisse gibt. Derzeit gibt es bereits einen ersten Prototyp von #studyPlan, welcher allerdings noch nicht produktiv genutzt wird.

Außerdem ist die Anwendung StudyGraph geplant, welche Studieninhalte visualisiert und somit auch die Informationen zu den angebotenen Modulen benötigt. @LernanwendungenAllerkampFakultat


=== Struktur des bestehenden Backends <backend>
Das bestehende Backend, auch #studybase genannt, ist mithilfe des auf JavaScript basierenden Framework #nest erstellt. #nest legt einen Fokus auf "effiziente, zuverlässige und skalierbare serverseitige Anwendungen" @nestjs.

Das #nest Backend ist modular aufgebaut.
Jede in @andereAnwendungen beschriebene Anwendung stellt im Backend ein Modul dar. Die Module der einzelnen Anwendungen enthalten ebenfalls Module, die die einzelnen Funktionen abbilden. Beispielsweise gibt es im Modul #studyPlan das Modul _degrees_, welches alle Studiengänge verwaltet.

Zusätzlich gibt es Module, die zwischen allen Anwendungen geteilt werden. Diese Shared-Modules bieten beispielsweise Funktionen zur Benutzerverwaltung und zum Versand von E-Mails an.

Um Funktionalitäten anbieten zu können, nutzen Module verschiedene Konzepte. Damit ein Modul beispielsweise eine HTTP-GET-Anfrage bearbeiten kann, muss es eine #text(controller)-Klasse haben. Ein #controller nimmt die Anfrage an und verarbeitet sie. Falls hierbei Daten benötigt werden, ruft der #controller eine Service-Klasse auf. Diese lädt die angefragten Daten aus der Datenbank und gibt sie an den #controller zurück. Für die Datenbankzugriffe wird Prisma genutzt.
Ein Auszug der Dateistruktur ist in @backendFiles zu sehen.

#pagebreak()
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
Es gibt eine schema.prisma-Datei (@moduletable), in der die Struktur der relationalen Datenbank definiert ist. Somit muss kein SQL geschrieben werden, sondern es können Methoden von Prisma genutzt werden. Es gibt Tabellen für Module und Studiengänge. Die Tabellen werden von Prisma generiert. Änderungen an der Struktur müssen demnach an der schema.prisma-Datei erfolgen. Dadurch ist die Struktur der Datenbank versioniert und kann in einer Quellcodeverwaltung abgelegt werden.

In @moduletable ist beispielsweise zu sehen, wie eine Tabelle mit dem Namen "Module" definiert ist. Die Tabelle hat unter anderem eine Spalte id, mit dem Datentyp Int und einen name mit dem Datentyp String.

#pagebreak()
#codeFigure("Auszug aus schema.prisma", <moduletable>, "moduleTablePrisma")

=== Struktur einer beispielhaften Angular Anwendung <angularStructureExample>
Eine Vorgabe dieser Arbeit ist es, Angular für die Entwicklung der Weboberfläche zu nutzen. Durch die Nutzung von Angular gibt es einen einheitlichen Techstack, da die geplanten Anwendungen (@andereAnwendungen) ebenfalls in Angular entwickelt werden sollen.

Eine Angular Anwendung besteht aus Komponenten und Seiten. Auf einer Seite werden 0 bis n Komponenten in einer HTML-ähnlichen Struktur organisiert.

Eine Komponente ist ein wiederverwendbares Element auf einer Website – beispielsweise ein Dropdown oder eine Textbox. Eine Komponente ist ebenfalls in der HTML-ähnlichen Struktur organisiert. In der Komponente können sich HTML-Elemente und andere Angular-Komponenten befinden.

Komponenten und Seiten haben eine .HTML-Datei für die Beschreibung der Struktur, eine .SCSS-Datei für die Beschreibung des Aussehens sowie eine .TS-Datei für kleinere Logiken. Geschäftslogik wird meist in separate #service#text("-Klassen") ausgelagert – ähnlich wie schon in @backend beschrieben. @angularStructure

== Interview mit Studiendekan <interview>
Da die Anforderungen sowie der aktuelle Arbeitsablauf noch unklar waren, musste eine Methode gefunden werden, um beides gründlich zu durchleuchten. Hierzu soll im Folgenden ein Interview durchgeführt werden. Ein Interview hat den entscheidenden Vorteil, dass der Verlauf des Gesprächs individuell angepasst werden kann. Wenn sich neue Fragen ergeben oder Fragen nicht ausreichend beantwortet wurden, kann im Interview direkt nachgefragt werden. @rupp_requirements-engineering_2014[Kapitel 6.3.3]

Das Interview wurde mit dem derzeitigen Studiendekan #heine durchgeführt. Das Interview orientierte sich an den Vorschlägen der #sophisten. Bereits bei der Einladung zum Interview wurden einige der Vorschläge beachtet. Der Studiendekan konnte sich den Interviewort selbst auswählen und erhielt die geplanten Fragen vorab zur Einsicht. Dadurch soll für den Interviewpartner eine möglichst angenehme Umgebung geschaffen werden, was zu einer erhöhten Kooperationsbereitschaft führen soll. @rupp_requirements-engineering_2014[Seite 107-109]
Die übersendeten Fragen können bei Interesse #link(<interviewFragen>)[im Anhang] nachgelesen werden.

Die Ergebnisse des Interviews sind in den folgenden Abschnitten zu lesen. Es ergaben sich zum einen die Konkretisierung der Zielgruppen, welche in @zielgruppen zu finden sind. Zum anderen wurde der aktuelle Arbeitsprozess klar definiert sowie dessen Schwachstellen aufgezeigt (@oldProcess).




== Analyse des aktuellen Arbeitsprozesses und Identifikation von Schwachstellen <oldProcess>
Der Prozess, um Modulhandbücher zu bearbeiten, hat sich bereits in der Planungsphase dieser Arbeit verändert. Bisher gab es für die Modulhandbücher Word-Dokumente, welche in einem Git-Repository verwaltet wurden. Bei Änderungen mussten jeweils das deutsche und das englische Word-Dokument bearbeitet werden. Anschließend kann es notwendig sein, die Änderungen auch im Curriculum des Studienganges (@mdiCurr) und im Anhang des besonderen Teils der Prüfungsordnung (@currTable) vorzunehmen.

Die kritischste Schwachstelle sind hier Redundanzen. Die Eigenschaften eines Modulhandbuches sind an mehreren verschiedenen Stellen hinterlegt und müssen überall von Hand angepasst werden. Bei dem manuellen Eintragen von Daten können schnell Fehler auftreten, da die verschiedenen Stellen nicht automatisch synchronisiert werden. @goll_entwurfsprinzipien_2018

Als Vorbereitung für ein neues System wurden vom Studiendekan die zuvor genannten Word-Dokumente maschinell eingelesen, in ein JSON-Format umgewandelt und anschließend in eine PostgreSQL-Datenbank eingespielt. Weiterhin wurde ein Python-Script erstellt, welches aus den Datensätzen in der Datenbank mithilfe von LaTeX ein PDF-Dokument für die Modulhandbücher generieren kann. Die Datenbank enthält jedoch weiterhin Redundanzen und könnte daher optimiert werden.

#pagebreak()

== Zielgruppen <zielgruppen>
Im folgenden Abschnitt sollen die verschiedenen Zielgruppen eines Modulhandbuches ermittelt und definiert werden. Die Übersicht der Zielgruppen wird für die später folgende Ermittlung der Use Cases benötigt (@usecases). Hierdurch wird ermöglicht zu verstehen, wer das Modulhandbuch verwenden wird und welche Anforderungen die verschiedenen Gruppen haben. Zur Ermittlung wurde zum einen im ECTS User-Guide @ects recherchiert und zum anderen das Interview (@interview) genutzt.


=== Studieninteressierte <studieninteressiertePerson>
Der ECTS User-Guide @ects beschreibt, dass Modulhandbücher bereits bei der Wahl eines Studiengangs helfen können. So können Personen, die an einem bestimmten Studiengang interessiert sind, mithilfe der Beschreibungen in den Modulhandbüchern herausfinden, welche Inhalte gelehrt werden. Modulhandbücher sind demnach eine gute Anlaufstelle, um einen ersten Eindruck zu den angebotenen Modulen eines Studienganges zu erhalten.


=== Studierende <student>
Eine weitere Zielgruppe sind Studierende. Das neue System könnte bei der Suche nach einem geeigneten Wahlpflichtfach unterstützen. Auch könnten Studierende mithilfe der Modulbeschreibungen verstehen, welche Inhalte in einem Modul gelernt werden und welche Voraussetzungen es gibt. Dadurch können Studierende einschätzen, ob sie genug Vorwissen für ein bestimmtes Modul haben. Weiterhin können Studierende mithilfe der Modulhandbücher zu jedem Modul einen Überblick über die zu erbringende Arbeitszeit erhalten sowie Informationen zu den Prüfungsleistungen finden.

=== Modulverantwortliche und Studiengangsverantwortliche <modulverantwortlicher>
Aus dem Interview mit dem Studiendekan (@interview) geht hervor, dass es neben den Studierenden noch andere zu betrachtende Zielgruppen gibt. Für die Bearbeitung von Modulhandbüchern sind an der #hsh verschiedene Personengruppen zuständig. Zum einen gibt es die studiengangverantwortliche Person (SVP). Diese ist für die Veröffentlichung des Dokumentes verantwortlich. Die SVP ist nicht dafür zuständig, die Inhalte der einzelnen Modulbeschreibungen anzupassen. Für diese Anpassungen gibt es die Modulverantwortlichen. Jedes Modul hat eine Person, die die Informationen der Modulbeschreibung aktuell halten soll und gleichzeitig Ansprechpartner für Fragen ist. In der Abteilung Informatik ist aktuell der Studiendekan gleichzeitig auch Studiengangverantwortlicher. Modulverantwortliche sind die Professoren und Dozierenden der Abteilung.


== Use Cases <usecases>
Im folgenden Abschnitt werden die Ergebnisse aus dem Interview und der Recherche im ECTS User Guide @ects verwendet, um aufzuzeigen, welche Funktionen die einzelnen Akteure im neuen System verwenden können.@rupp_requirements-engineering_2014[Seite~192] Hierzu werden Use Cases bestimmt, damit im nächsten Abschnitt (@requirements) daraus Anforderungen abgeleitet werden können. Die Use Cases wurden hergeleitet, indem die Bedürfnisse und Aufgaben der Akteure analysiert und mit den im ECTS User Guide beschriebenen Funktionen abgeglichen wurden. So soll sichergestellt werden, dass alle zuvor bestimmten Akteure ihre Aufgaben vollständig mit dem neuen System erledigen können.



/*
  "Sie können Use Case-Beschreibungen als Ergänzung zu Use Case-Diagrammen erstellen, etwa um jeden einzelnen Use Case aus dem Diagramm genauer zu beleuchten. Use Case Beschreibungen können aber auch ohne Diagramm für sich stehen."
*/

#include("Planung/use-cases.typ")

Die Auflistung der Use Cases bildet eine Grundlage für die folgenden Abschnitte. Aus den Use Cases können nun konkrete Anforderungen ermittelt werden. Sicherlich können verschiedene Menschen noch weitere Ideen zur Verwendung des Systems haben, jedoch sollte diese Auflistung die wichtigsten Punkte umfassen, um ein System abzubilden, welches den aktuellen Workflow verbessert. Es ist wichtig zu betonen, dass sich Anforderungen stetig verändern können und dass es möglich ist in Zukunft auch andere Use Cases durch das System abzudecken. Das System soll deshalb so implementiert werden, dass zukünftige Änderungen einfach möglich sind.  


== Anforderungen <requirements>
Als Nächstes sollen konkrete Anforderungen an das zukünftige System aufgestellt werden. Diese Anforderungen sollen zum einen dabei helfen, in der Entwurfs- und Implementierungsphase (@entwurf,~ @implementierung) konkrete Vorgaben zu haben, die abgearbeitet werden können, und zum anderen in @review ermitteln zu können, ob das System einsetzbar ist.

Die Anforderungen an das System leiten sich aus den Use Cases, einer ISO-Norm und der Systemumgebung ab. Diese lassen sich in zwei Kategorien unterteilen: funktionale Anforderungen (basierend auf den Use Cases) und nicht-funktionale Anforderungen (abgeleitet aus der ISO-Norm und der Systemumgebung).

Um die Herkunft der Anforderungen klar darzustellen, werden sie in funktionale und nicht-funktionale Anforderungen gegliedert. Obwohl diese Trennung fachlich nicht zwingend erforderlich ist, dient sie der besseren Übersichtlichkeit der folgenden Auflistung.

Jede Anforderung in den folgenden Auflistungen enthält entweder das Wort "muss", "sollte" oder "könnte". @rupp_requirements-engineering_2014[Kapitel 1.5.2] Damit wird zwischen Anforderungen unterschieden, die zwingend erforderlich sind (muss), Anforderungen, die sehr sinnvoll sind (sollte), und Anforderungen, die nicht zwingend erforderlich sind, aber die Nutzer begeistern würden (könnte). Eine weitere Priorisierung wird an dieser Stelle nicht benötigt, sondern kann bei Bedarf erfolgen.

#import "@preview/gentle-clues:0.7.1": *



#block(breakable: false)[
=== Funktionale Anforderungen
Die funktionalen Anforderungen ergeben sich aus den zuvor ermittelten Use Cases (@usecases). Hierbei wurde überlegt, welche Anforderungen erfüllt sein müssen, um einen Use Case vollständig abbilden zu können.

In #link(<UseCaseInfoDegree>)[Use Case 1] ist beschrieben, wie eine nicht angemeldete Person (NP) Informationen zu einem Studiengang erhalten möchte. Damit die Übersicht eines Studienganges auf der Website der Hochschule verlinkt werden kann, muss das System einen Link bereitstellen können, der direkt zur Übersicht führt und sich nicht verändert. Außerdem muss es eine Funktion geben, um das PDF mit dem Modulverzeichnis des Studienganges zu öffnen.

#task(title:[Aus #link(<UseCaseInfoDegree>)[Use Case 1] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Link zur Übersichtsseite anbieten", type: "F", label: <StaticLink>)[System muss einen statischen Link zur Übersicht eines Studienganges bereitstellen.]
  #narrowTrack("PDF anzeigen", type: "F", label: <PDF>)[NP muss ein PDF mit allen Modulbeschreibungen ansehen können.]
]
]

#linebreak()

#block(breakable: true)[
  


In #link(<UseCaseInfoModule>)[Use Case 2] ist beschrieben, wie eine Person Informationen zu einem Modul erhalten möchte. Das System muss hierzu alle Module des ausgewählten Studiengangs auflisten. Die Module müssen auswählbar sein, damit weitere Details angezeigt werden können. Im genannten Beispiel ist die Person auf der Suche nach einem Wahlpflichtmodul. Für diesen Fall muss das System die Möglichkeit bieten, nach bestimmten Informationen zu filtern. Denkbar wären Filter für die Informationen "Wahlpflichtfach", "Semester", "Erreichbare Credits".


#task(title: [Aus #link(<UseCaseInfoModule>)[Use Case 2] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Module auflisten", type: "F", label: <SHOWMODULES>)[NP muss eine Liste aller Module sehen können.]
  #narrowTrack("Filterfunktion", type: "F", label: <FILTER>)[NP sollte Filter nutzen können, um das gesuchte Modul zu finden.]
  #narrowTrack("Suchfunktion", type: "F", label: <SEARCH>)[NP sollte eine Suchfunktion nutzen können, um das gesuchte Modul zu finden.]
  #narrowTrack("Module anzeigen", type: "F", label: <SHOWMODULEDETAIL>)[NP muss die Details eines Moduls ansehen können.]
]
]

#linebreak()

#block(breakable: true)[


In #link(<UseCaseEditModule>)[Use Case 3] ist beschrieben, wie eine Person Informationen zu einem Modul bearbeiten möchte. Damit dies nur vom genannten Akteur erledigt werden kann, wird eine Login-Funktion benötigt. Aus der Login-Funktion ergeben sich weitere Anforderungen. So kann ein Logout-Button sinnvoll sein und es könnte praktisch sein, das eigene Passwort ändern zu können. Weiterhin könnte es hilfreich sein, wenn die eingegebenen Informationen auf Plausibilität überprüft werden. Denkbar wäre beispielsweise eine Prüfung, ob die angegebenen ECTS mit dem angegebenen Zeitaufwand zusammenpassen.

#task(title: [Aus #link(<UseCaseEditModule>)[Use Case 3] ergeben sich folgende Anforderungen:])[
#narrowTrack("Login", type: "F", label: <LOGIN>)[Ein User muss sich anmelden können.] #linebreak()
#narrowTrack("Logout", type: "F", label: <LOGOUT>)[Ein User sollte sich ausloggen können.] #linebreak()
#narrowTrack("Passwörter zurücksetzen", type: "F", label: <RESETPW>)[SVP sollte Passwörter zurücksetzen können.]
#narrowTrack("Eigenes Passwort zurücksetzen", type: "F", label: <RESETMYPW>)[SVP sollte das eigene Passwort zurücksetzen können.]
  #narrowTrack("Module bearbeiten", type: "F", label: <EDIT>)[Modulverantwortliche Person muss Module bearbeiten können, für die sie als Ansprechpartner hinterlegt ist.]
  #narrowTrack("Plausibilitätschecks bei Modulen", type: "F", label: <CHECKMOD>)[System sollte Änderungen an Modulen auf Plausibilität prüfen.]
]
]

#linebreak()

#block(breakable: true)[

In #link(<UseCaseCreate>)[Use Case 4] ist beschrieben, dass die studiengangsverantwortliche Person Datensätze erstellen können muss. Für die verschiedenen Entitäten im neuen System muss es dementsprechend jeweils eine Bearbeitungsmaske geben. Im System müssen die Datensätze sowohl erstellbar als auch bearbeitbar sein. Außerdem muss man Datensätze löschen können. Aus dem Interview mit dem Studiendekan hat sich außerdem ergeben, dass Studiengänge ausblendbar sein müssen, damit alte Prüfungsordnungen versteckt werden können. Diese werden von Studierenden nicht benötigt, weil darin enthaltene Veranstaltungen möglicherweise nicht mehr angeboten werden. Die veralteten Studiengänge sollen jedoch nicht direkt gelöscht werden, damit der Studiendekan bei Bedarf auf alte Modulbeschreibungen zugreifen kann. Für die Erstellung einer neuen Prüfungsordnung schlägt der Studiendekan eine Funktion vor, die bestehende Studiengänge oder Module duplizieren kann, da es manchmal zwischen den Prüfungsordnungen nur geringfügige Änderungen gibt.

#task(title: [Aus #link(<UseCaseCreate>)[Use Case 4] ergeben sich folgende Anforderungen:])[
  #narrowTrack("Module verwalten", type: "F", label: <MODULE>)[SVP muss Module verwalten (anlegen, bearbeiten, löschen) können.]
  #narrowTrack("Module duplizieren", type: "F", label: <DUPLICATE>)[SVP sollte Module duplizieren können.]#linebreak()
  #narrowTrack("Studiengänge verwalten", type: "F", label: <COURSE>)[SVP sollte Studiengänge verwalten können.]
  #narrowTrack("Studiengänge duplizieren", type: "F", label: <DUPLICATECourse>)[SVP sollte Studiengänge duplizieren können.]
  #narrowTrack("Studiengänge ausblenden", type: "F", label: <hideCourse>)[SVP sollte Studiengänge ausblenden können.]
  #narrowTrack("Ausgeblendete Studiengänge ansehen", type: "F", label: <showHiddenCourses>)[SVP sollte ausgeblendete Studiengänge ansehen können.]
  #narrowTrack("Benutzer verwalten", type: "F", label: <CRUSER>)[SVP sollte User verwalten können.]#linebreak()
  #narrowTrack("Teilmodule verwalten", type: "F", label: <CreateSubmodules>)[SVP muss Teilmodule verwalten können.]  
  #narrowTrack("Voraussetzungen verwalten", type: "F", label: <CreateRequirements>)[SVP muss Voraussetzungen verwalten können.]
]

]

#block(breakable: false)[
In #link(<UCRevertChanges>)[Use Case 5] ist beschrieben, dass die Änderungen an einem Modul rückgängig gemacht werden können. Hierzu müssen diese zunächst angezeigt werden. Diese Funktion ist außerdem für Teilmodule und auch alle anderen Arten von Datensätzen sinnvoll.

#task(title: [Aus #link(<UCRevertChanges>)[Use Case 5] ergibt sich folgende Anforderung:])[
  #narrowTrack("Änderungen anzeigen (Modul)", type: "F", label: <SHOWCHANGES>)[SVP sollte sich einzelne Änderungen an einem Modul anzeigen lassen können.]
  #narrowTrack("Änderungen widerrufen (Modul)", type: "F", label: <REVERT>)[SVP könnte einzelne Änderungen an einem Modul rückgängig machen.]
  #narrowTrack("Änderungen anzeigen", type: "F", label: <SHOWCHANGESmisc>)[SVP könnte sich einzelne Änderungen an beliebigen Datensätzen anzeigen lassen können.]
  #narrowTrack("Änderungen widerrufen", type: "F", label: <REVERTmisc>)[SVP könnte einzelne Änderungen an beliebigen Datensätzen rückgängig machen.]
]

#linebreak()

In #link(<UseCaseTable>)[Use Case 6] ist beschrieben, wie die studiengangsverantwortliche Person den Anhang der Prüfungsordnung erstellt. Da die Prüfungsordnung ein wichtiges Dokument ist, soll diese auch in Zukunft zunächst manuell erstellt werden. Die im Anhang der Prüfungsordnung enthaltene Tabelle kann dann im System generiert werden und kann mit der manuell erstellten Tabelle verglichen werden. Hiermit ist dann sichergestellt, dass die Daten im neuen System und in der Prüfungsordnung übereinstimmen.
#task(title: [Aus #link(<UseCaseTable>)[Use Case 6] ergibt sich folgende Anforderung:])[
  #narrowTrack("Anhang der Prüfungsordnung", type: "F", label: <COMPARE>)[SVP könnte sich die Auflistung aller Module als Tabelle anzeigen lassen, um sie mit dem Anhang der Prüfungsordnung vergleichen zu können.]
]
]

#pagebreak()
=== Nicht-Funktionale Anforderungen
Die nicht-funktionalen Anforderungen ergeben sich aus einem Brainstorming unter der Berücksichtigung der ISO-Norm ISO/IEC 25000 @rupp_requirements-engineering_2014[Kapitel 12] und ergeben sich aus den Bedingungen aus @architecture.


Die ISO-Norm 25000 beschreibt verschiedene Merkmale, die zur Messung von Softwarequalität genutzt werden können. Um eine gute Softwarequalität zu erreichen, sollten aus allen Merkmalen konkrete Anforderungen an das neue System abgeleitet werden. Die Merkmale sind jeweils in Submerkmale unterteilt. Nicht jedes Submerkmal ist für das neue System relevant, jedoch sollten möglichst viele Submerkmale in Anforderungen übersetzt werden, um eine gute Qualität sicherzustellen.



Das Merkmal #emph("Änderbarkeit") besteht aus den Submerkmalen #emph("Analysierbarkeit"), #emph("Modifizierbarkeit"), #emph("Stabilität") und #emph("Testbarkeit") @rupp_requirements-engineering_2014[12.4.1]. Damit Software diese Kriterien erfüllt, muss der Quellcode eine hohe Qualität aufweisen. Daher soll das System einigen Prinzipien folgen, die in von #cite(<clean_code_2012_robert_martin>, form: "author") beschrieben sind. @clean_code_2012_robert_martin Der Quellcode soll so geschrieben sein, dass mit geringem Aufwand jede Klasse und jede Methode verstanden werden kann. Alle Teile des Codes sollen selbsterklärend und möglichst kurz sein. Komplexe Abläufe sollen in Teilabläufe aufgeteilt werden, sodass Methoden und Klassen eine gewisse Größe und Komplexität nicht überschreiten und somit innerhalb kurzer Zeit von nachfolgenden Entwicklern verstanden werden können. @clean_code_2012_robert_martin[Kapitel 1] Der Quellcode kann dadurch auf eine effiziente Art von Entwickelnden analysiert werden (#emph("Analysierbarkeit")). Durch den Einsatz von Dependency Injection können Abhängigkeiten ausgetauscht werden (#emph("Modifizierbarkeit")). Durch das gezielte Einsetzen von Fehlermeldungen und Try-Catch-Blöcken wird für eine gute #emph("Stabilität") des Systems gesorgt. @clean_code_2012_robert_martin[Kapitel 7] Abschließend ergeben sich aus kleinen Komponenten mit genau einer Verantwortlichkeit und wenigen Abhängigkeiten gut testbare Einheiten, die mit automatisierten Tests getestet werden könnten. @clean_code_2012_robert_martin[Kapitel 9]


#task(title: [Änderbarkeit])[
  #narrowTrack("Modularität", type:"N", label: <MODULAR>)[
  Der Quellcode des Systems sollte aus Komponenten bestehen.
]

  #narrowTrack("Wiederverwendbarkeit", type:"N", label: <TESTABLE>)[
  Einzelne Komponenten könnten wiederverwendbar sein.
]

  #narrowTrack("Hohe Kohärenz", type:"N", label: <Verantwortlichkeit>)[
  Die Komponenten sollten genau eine Verantwortlichkeit haben.
]

  #narrowTrack("Lose Kopplung", type:"N", label: <Kopplung>)[
  Die Komponenten dürfen nicht zu viele Abhängigkeiten haben.
]

  #narrowTrack("Komplexität", type:"N", label: <Komplex>)[
  Methoden und Klassen sollen eine geringe Komplexität haben.
]

  #narrowTrack("Dependency Injection", type:"N", label: <DepedencyInjection>)[
  Durch die Nutzung von Dependency Injection sollen Abhängigkeiten austauschbar sein.
]

#narrowTrack("Stabilität", type:"N", label:<Stability>)[
  Mithilfe von Fehlercodes und Try-Catch-Anweisungen sollen Fehler abgefangen werden.
]

#narrowTrack("Unittests", type:"N", label:<TEST>)[
  Geschäftslogik könnte mithilfe von Unittests automatisiert getestet werden.
]

#narrowTrack("e2e-Tests", type:"N", label:<TESTUI>)[
  System könnte mithilfe von e2e-Tests automatisiert getestet werden.
]
]


Das Merkmal #emph("Benutzbarkeit") besteht aus den Submerkmalen #emph("Verständlichkeit"), #emph("Erlernbarkeit"), #emph("Bedienbarkeit"), #emph("Attraktivität") und #emph("Konformität"). @rupp_requirements-engineering_2014[12.4.1]
Für die Ermittlung der folgenden Anforderungen wurde in einem Brainstorming überlegt, wie die Submerkmale der Benutzbarkeit in konkrete Anforderungen übersetzt werden können. Beispiel: Damit eine Oberfläche verständlich ist, sollte sie selbsterklärend sein und nicht das Lesen eines Benutzerhandbuches erfordern (#emph("Verständlichkeit")).

Die folgenden Anforderungen sind kein 1:1-Abbild der zukünftigen Anwendung, sondern legen eher die Grundprinzipien fest, die bei der Entwicklung beachtet werden sollen. Eine vollständige Spezifikation wäre an dieser Stelle sehr aufwändig und ist daher nicht notwendig.

#task(title: [Benutzbarkeit])[
  #narrowTrack("Aktueller Pfad", type:"N", label: <PATH>)[
  System könnte anzeigen, welcher Pfad aufgerufen wurde \ (z. B. Fakultät->Studiengang->Modul).
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

Das Merkmal #emph("Effizienz") besteht aus den Submerkmalen #emph("Zeitverhalten"), #emph("Verbrauchsverhalten") und #emph("Konformität"). @rupp_requirements-engineering_2014[12.4.1]
Damit das System eine gute Effizienz hat, müssen alle Anfragen performant gestaltet werden. In den Anforderungen werden Grenzwerte gesetzt, die das System erreichen soll. Falls einzelne Seiten viele Daten laden müssen, sodass die gesetzten Ziele nicht erreicht werden können, müssen diese Daten im Hintergrund geladen werden, sodass die Seite selbst geladen wird und fehlende Daten dann nachträglich eingesetzt werden können. Unter dem Begriff der Effizienz könnte auch die Effizienz des Entwicklungsprozesses oder die Effizienz der Aufgabenerledigung verstanden werden, weshalb zu diesen Gebieten auch Anforderungen erstellt wurden.

#task(title: [Effizienz])[
  
  #narrowTrack("Startzeit Frontend", type:"N", label:<STARTFRONTEND>)[
  Jede Seite im Frontend sollte innerhalb einer Sekunde geladen sein.
]
#narrowTrack("Startzeit Backend", type:"N", label:<STARTBACKEND>)[
  Das Backend sollte im kritischen Fehlerfall innerhalb einer Minute neu starten.
]
  #narrowTrack("Deployment", type:"N", label:<DEPLOY>)[
  Das Deployment könnte automatisiert sein.
]
  #narrowTrack("Effizienz der Aufgabenerledigung", type:"N", label:<CLICKS>)[
  Jeder Schritt im Use Case sollte mit möglichst wenigen Klicks absolvierbar sein.
]
]


Das Merkmal #emph("Funktionalität") besteht aus den Submerkmalen #emph("Angemessenheit"), #emph("Richtigkeit"), #emph("Interoperabilität"), #emph("Sicherheit") und #emph("Ordnungsmäßigkeit"). @rupp_requirements-engineering_2014[12.4.1] Da die Modulhandbücher bisher in Englisch und Deutsch bereitstehen, muss diese Funktionalität bestehen bleiben. Für die Zukunft wäre auch die Einführung weiterer Sprachen denkbar, weshalb die Mehrsprachenfähigkeit vorbereitet werden sollte. Um den Arbeitsaufwand gering zu halten, sollte das System sinnvolle Eingaben vorschlagen und das generierte PDF sollte dem ursprünglichen PDF ähneln. Außerdem muss sichergestellt sein, dass bestimmte Endpunkte nur von autorisierten Nutzern verwendet werden können.

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
#narrowTrack("Ähnlichkeit zum ursprünglichen PDF", type:"N", label: <similarPdf>)[
  Das generierte PDF sollte dem ursprünglichen PDF ähneln.
]
#narrowTrack("Sicherheit", type:"N", label: <security>)[
  Es muss verhindert werden, dass nicht autorisierte Benutzer datenverändernde Endpunkte nutzen.
]
]

Das Merkmal #emph("Übertragbarkeit") besteht aus den Submerkmalen #emph("Anpassbarkeit"), #emph("Installierbarkeit"), #emph("Koexistenz"), #emph("Austauschbarkeit") und #emph("Konformität"). @rupp_requirements-engineering_2014[12.4.1] Eine vereinfachte Installierbarkeit könnte durch den Einsatz von Podman- oder Docker-Containern erreicht werden. Damit zukünftige Anwender das System installieren können, wird zudem eine Dokumentation benötigt. Weiterhin sollte das System aus austauschbaren Komponenten bestehen. Es ist beispielsweise denkbar, in Zukunft eine andere Datenbank zu nutzen oder andere Kompilierungsserver einzusetzen.

#task(title: [Übertragbarkeit])[
  #narrowTrack("Dokumentation zur Installation", type:"N", label: <DOKBACK>)[
  Es sollte dokumentiert sein, wie das System installiert wird.
]
#narrowTrack("Container", type:"N", label: <containerAnf>)[
  Es könnten Podman-Container genutzt werden, um die Komponenten des Systems bereitzustellen.
]
#narrowTrack("Austauschbarkeit", type:"N", label: <austauschbarkeit>)[
  Einzelne Komponenten sollten austauschbar sein (Datenbank, Kompilierungsserver, Frontend).
]
]

Das Merkmal #emph("Zuverlässigkeit") besteht aus den Submerkmalen #emph("Reife"), #emph("Fehlertoleranz"), #emph("Robustheit"), #emph("Wiederherstellbarkeit") und #emph("Konformität"). Das System sollte mit Fehlern umgehen können. Diese sollten entweder abgefangen oder dem Benutzer mitgeteilt werden. Besser wäre es, wenn während der Erledigung der Use Cases keine Fehler auftreten würden. Gegen den Schutz vor Angriffen könnten Rate-Limits ein sinnvoller Mechanismus sein, um beispielsweise nach mehreren fehlgeschlagenen Loginversuchen weitere Versuche zu unterbinden.

#task(title: [Zuverlässigkeit])[
  #narrowTrack("Stabilität", type:"N", label: <ERRORSTABLE>)[
  Das System muss bei auftretenden Fehlern weiterhin funktionieren / sich selbst wiederherstellen.
]
#narrowTrack("Reife", type:"N", label: <reife>)[
  Das System sollte beim Erledigen der Use Cases keine Fehler erzeugen.
]
#narrowTrack("Robustheit", type:"N", label: <robustheit>)[
  Das System sollte Rate-Limits nutzen, um bei größeren Lasten gegebenenfalls Anfragen zu blockieren.
]
]


In @architecture sind die bereits bestehenden Anwendungen beschrieben. Aus diesen Erkenntnissen ergeben sich einige technische Anforderungen, die bei der Entwicklung beachtet werden müssen.
#task(title: [Technische Anforderungen])[
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
  Das Backend muss Prisma und NestJS nutzen.
]

#narrowTrack("Bestehende Datenbank", type:"N", label: <DB>)[
  Die bestehende Datenbank muss erweitert werden.
]
]

=== Ergebnis
Das Ergebnis dieses Abschnittes ist eine Auflistung der Anforderungen an das neue System. Diese sollte alle zuvor aufgestellten Use Cases abdecken. Außerdem gibt es weitere Anforderungen, die eine gute Softwarequalität gewährleisten sollen und die Rahmenbedingungen der späteren Entwicklung bestimmen. In @review kann anhand der Auflistung überprüft werden, ob das neue System für die produktive Verwendung einsatzbereit ist.





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
In diesem Unterabschnitt soll die Struktur eines Modulhandbuches analysiert werden, um herauszufinden, wie die spätere Datenbank aufgebaut sein muss. Damit ein Datenbankschema erstellt werden kann, müssen die verschiedenen Entitäten ermittelt werden, die Beziehung zwischen den Entitäten und die Attribute für jede Entität.

Die Modulhandbücher der Abteilung Informatik haben für alle drei Studiengänge (BIN, MDI und MIN) dieselbe Struktur. Es gibt eine Aufteilung in Module und Teilmodule. Ein Modul kann dabei 0 bis n verschiedene Teilmodule haben und jedes Teilmodul kann zu 1 bis n Modulen gehören. Teilmodule können studiengangsübergreifend mit Modulen verknüpft werden. #emph("Beispiel"): Es gibt das Modul "MDI-103 Grundlagen der Informatik" und das Modul "BIN-103 Grundlagen der Informatik". Beide verweisen auf das Teilmodul "BIN-103-01 Grundlagen der Informatik". Somit können studiengangsübergreifende Module abgebildet werden. In der Regel hat an der Abteilung Informatik jedes Modul genau ein Teilmodul und umgekehrt gehört in der Regel jedes Teilmodul zu genau einem Modul.

=== Moduleigenschaften <properties>

Das Modul enthält zunächst grundlegende Informationen. Diese werden aufgelistet, um ein besseres Verständnis der benötigten Datenstruktur zu erhalten. Jedes aufgelistete Feld soll später in @schema implementiert werden, daher ist es notwendig, die benötigten Felder und deren Inhalt herauszufinden. 

#track("Titel", example: "BIN-100 Mathematik 1", label:<title>)[
  Zusammengesetzt aus einem Kürzel des Studiengangs, einer eindeutigen Zahl und dem Namen des Moduls.
]

#track("Untertitel", example: "Mathematische Grundlagen der Informatik (BIN-MAT1) oder C/C++ (BIN-PR3)", label:<subTitle>)[
  Ein alternativer, ggf. etwas präziserer Name des Moduls sowie ein Kürzel. In den aktuell veröffentlichten Handbüchern ist hier oft nur das Kürzel angegeben.
]

#track("Modulniveau")[
  Hier ist angegeben, ob das Modul ein Grundlagenmodul oder Vertiefungsmodul ist.
]

#track("Pflicht / Wahlpflicht")[
  Hier ist angegeben, ob das Modul ein Pflichtmodul oder Wahlpflichtmodul ist.
  Studierende müssen alle Pflichtmodule absolvieren und müssen eine bestimmte Anzahl an selbst ausgewählten Wahlpflichtmodulen absolvieren.
]

#track("Teilmodule", label:<submodules>)[
  Eine Auflistung aller Teilmodule.
]

#track("Verantwortliche(r)", example: "Wohlfeil, Stefan, Prof. Dr.", label: <responsible>)[
  Name der verantwortlichen Person. Diese Person ist für die Bearbeitung des Modulhandbuches zuständig.
]

#track("Credits", label: <credits>)[
  Anzahl erreichbarer ECTS bei Absolvierung dieses Moduls. Eine Zahl zwischen 2 (Englisch) und 30 (z. B. Masterarbeit).
]

#track("Präsenzstunden / Selbststudium", example: "68 h / 112 h", label:<hours>)[
  Aufwand des Studiums, aufgeteilt nach der Zeit, die in der Hochschule verbracht wird, und der Zeit, die im Selbststudium verbracht wird (Arbeit an Übungen, Prüfungsvorbereitung …).
]

#track("Studiensemester", label: <recommendedSemester>, example: "4-6")[
  Vorgeschlagenes Semester. Anhand dieser Information wird das Curriculum generiert (@mdiCurr).
]

#track("Moduldauer", example: "1 Semester")[
  Hier ist angegeben, wie lange es dauert, das Modul zu absolvieren.
]

#track("Voraussetzungen nach Prüfungsordnung", example: "Alle Modulprüfungen des 1. bis 3. Semesters")[
  Für die Absolvierung des Moduls zwingend erforderliche Voraussetzungen.
]

#track("Empfohlene Voraussetzungen", example: "Alle Module der Semester 1 bis 3 sowie BIN-112 und BIN-202", label: <recommendedRequirements>)[
  Für die Absolvierung des Moduls empfohlene Voraussetzungen.
]

#track("Studien-/ Prüfungsleistungen", example: "Referat (Hausarbeit plus Präsentation/Vortrag), Anwesenheitspflicht", label:<exam>)[
  Eine kommagetrennte Auflistung der zu erbringenden Leistungen.
]

#track("Angestrebte Lernergebnisse", example: "Die Studierenden sind in der Lage, dreidimensionale Objekte zu gestalten, zu bewegen und zueinander in Beziehung zu setzen.", label:<erg>)[
  Eine stichpunktartige, kommagetrennte Auflistung der Kompetenzen, die in diesem Modul erworben werden.
]

#track("Gruppe", example: "Wahlpflichtmodule 2. Studienabschnitt", label:<group>)[
  Jedes Modul gehört zu einer Gruppe. Anhand der Gruppe werden die Module im PDF gedruckt.
]

#text(" ")<EndOfChapter>

=== Teilmoduleigenschaften<submoduleProps>
Die Teilmodule haben ebenfalls die Informationen: @subTitle, @responsible, @credits, @hours, @recommendedSemester, @recommendedRequirements, @exam und @erg.
Zusätzlich gibt es noch weitere benötigte Felder.

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
  Eine Kurzbeschreibung zum Ablauf der Veranstaltung sowie deren Dauer in Semesterwochenstunden.
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
Reges, S., Stepp, M.: Building Java Programs, Prentice Hall", label: <literature>)[
  Eine Auflistung empfohlener Literatur zur Vertiefung des behandelten Themas.
]

== Zwischenfazit
In diesem Kapitel wurden mithilfe verschiedener Methoden die Schwachstellen des alten Prozesses ermittelt und daraus im Anschluss Anforderungen an das neue System ermittelt. Hierbei half die Aufstellung von Zielgruppen und Anwendungsfällen. Die aufgestellten Anforderungen helfen bei der folgenden Planung der Anwendung und werden auch später im @review hilfreich sein, um zu ermitteln, ob das neue System eingesetzt werden kann. Die zum Ende des Kapitels herausgearbeitete Struktur der Modulhandbücher kann im Folgenden zur Entwicklung einer passenden Datenstruktur helfen.

