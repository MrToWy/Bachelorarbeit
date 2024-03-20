#import "../Template/customFunctions.typ": *

= Anforderungsanalyse <anforderungsanalyse>

Die Planung des neuen Systems für Modulhandbücher beginnt mit der Anforderungsanalyse. Der Schritt der Anforderungsanalyse hat eine besondere Wichtigkeit, da es mit fortlaufender Projektlaufzeit immer aufwändiger wird, Fehler zu korrigieren oder Anpassungen vorzunehmen. @kleuker_grundkurs_2013[Seite 55] Damit diese wichtige Phase gründlich absolviert wird, folgt der Ablauf der Anforderungsanalyse den Empfehlungen von Chris Rupp und den #sophisten @rupp_requirements-engineering_2014. Es werden zunächst der aktuelle Arbeitsprozess und die Architektur benachbarter Systeme analysiert und deren Probleme erkundet. Anschließend werden die Zielgruppen des neuen Systems ermittelt. Abschließend werden Ziele definiert.


== Architektur
In der Abteilung Informatik der #hsh gibt es bereits mehrere Anwendungen, die ein gemeinsames Backend nutzen. Dieses Backend soll in dieser Arbeit erweitert werden, um auch den anderen Anwendungen die Auflistung der Modulhandbücher anbieten zu können. Zusätzlich wird eine neue Anwendung erstellt, die mit dem angepassten Backend kommunizieren wird.


=== Bestehende Anwendungen <andereAnwendungen>

Für Studierende, die planen möchten, welches Modul sie in welchem Semester erledigen, gibt es die Anwendung #studyPlan. Hier können Studierende vom vorgeschlagenen Studienverlauf abweichen und dabei sicherstellen, trotzdem alle Module in der gewünschten Zeit zu erledigen. #studyPlan wird von dem angepassten Backend profitieren, weil #studyPlan eine stets aktuelle Auflistung aller Module inklusive deren Zeitaufwände benötigt.

Die Entwicklung von #studyPlan läuft parallel zur Entwicklung dieser Bachelorarbeit – es muss also sichergestellt werden, dass es rechtzeitig nutzbare Ergebnisse gibt.

Außerdem gibt es die Anwendung #gls("StudyGraph"), welche Studieninhalte visualisiert und somit auch die Informationen zu den angebotenen Modulen benötigt.


=== Struktur des bestehenden Backends <backend>
Das bestehende Backend, auch #studybase genannt, ist mithilfe des auf JavaScript basierenden Framework #nest erstellt. #nest legt einen Fokus auf "effiziente, zuverlässige und skalierbare serverseitige Anwendungen" @nestjs.

Das #nest Backend ist modular aufgebaut.
Jede in @andereAnwendungen beschriebene Anwendung stellt im Backend ein Modul dar. Die Module der einzelnen Anwendungen enthalten ebenfalls Module, die die einzelnen Funktionen abbilden. Beispielsweise gibt es im Modul #studyPlan das Modul _degrees_, welches alle Studiengänge verwaltet.

Zusätzlich gibt es Module, die zwischen allen Anwendungen geteilt werden. Diese Shared-Modules bieten beispielsweise Funktionen zur Benutzerverwaltung und zum Versand von Emails an.

Damit Module Funktionalitäten anbieten können, nutzen sie verschiedene Konzepte. Damit ein Modul beispielsweise eine HTTP-GET-Anfrage bearbeiten kann, muss es eine #gls("Controller")-Klasse haben. Ein #gls("Controller") nimmt die Anfrage an und verarbeitet sie. Falls hierbei Daten benötigt werden, ruft der #gls("Controller") eine #gls("Service")-Klasse auf. Diese lädt die angefragten Daten aus der Datenbank und gibt sie an den #gls("Controller") zurück. Für die Datenbankzugriffe wird #gls("Prisma") genutzt. 

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
Es gibt eine schema.prisma-Datei, in der die Struktur der relationalen Datenbank definiert ist. Somit muss kein SQL geschrieben werden, sondern es können Methoden von #gls("Prisma") genutzt werden. Es gibt Tabellen für Module und Studiengänge. Die Tabellen werden von #gls("Prisma") generiert. Änderungen an der Struktur müssen demnach an der schema.prisma-Datei erfolgen. Dadurch ist die Struktur der Datenbank versioniert und kann in einer Quellcodeverwaltung abgelegt werden.

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


=== Studierende
Der ECTS User-Guide @ects beschreibt, dass Modulhandbücher Studierenden vor und während ihrem Studium helfen. Studierende können mithilfe der Modulbeschreibungen verstehen, welche Inhalte in einem Modul gelernt werden und welche Voraussetzungen es gibt. Dadurch können Studierende einschätzen, ob die Wahl eines bestimmten Moduls – oder sogar eines gesamten Studienganges – für sie sinnvoll ist. Weiterhin können Studierende dank der Modulhandbücher zu jedem Modul den korrekten Ansprechpartner finden, einen Überblick über die zu erbringende Arbeitszeit erhalten, sowie Informationen zu den Prüfungsleistungen finden. 


=== Modulverantwortliche und Studiengangverantwortliche
Aus dem Interview mit dem Studiendekan (@interview) geht hervor, dass es neben den Studierenden noch andere zu betrachtende Zielgruppen gibt. Für die Bearbeitung von Modulhandbüchern sind an der #hsh verschiedene Personengruppen zuständig. Zum einen gibt es den Studiendekan. Dieser ist für die Veröffentlichung des Dokumentes verantwortlich. Der Studiendekan ist nicht dafür zuständig, die Inhalte der einzelnen Modulbeschreibungen anzupassen. Für diese Anpassungen gibt es die Modulverantwortlichen. Jedes Modul hat eine Person, die die Informationen der Modulbeschreibung aktuell halten soll und gleichzeitig Ansprechpartner für Fragen ist.


== Use Cases <usecases>
/*

Die Ergebnisse aus dem Interview werden mithilfe der Use–Case–Modellierung verwendet, um aufzuzeigen, welche Funktionen die einzelnen Akteure im neuen System verwenden können.


  "Sie können Use-Case-Beschreibungen als Ergänzung zu Use-Case-Diagrammen erstellen, etwa um jeden einzelnen Use-Case aus dem Diagramm genauer zu beleuchten. Use-Case Beschreibungen können aber auch ohne Diagramm für sich stehen."
@rupp_requirements-engineering_2014[s.~192]

*/



== Anforderungen 

/*

@rupp_requirements-engineering_2014[Kapitel 5.3]


sollte / muss als Schlüsselwörter
@rupp_requirements-engineering_2014[Kapitel 1.5.2]

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
