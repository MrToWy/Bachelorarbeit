#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *

= Anforderungsanalyse <anforderungsanalyse>

Die Planung des neuen Systems für Modulhandbücher beginnt mit der Anforderungsanalyse. Der Schritt der Anforderungsanalyse hat eine besondere Wichtigkeit, da es mit fortlaufender Projektlaufzeit immer aufwändiger wird, Fehler zu korrigieren oder Anpassungen vorzunehmen. @kleuker_grundkurs_2013[Seite 55] Damit diese wichtige Phase gründlich absolviert wird, folgt der Ablauf der Anforderungsanalyse den Empfehlungen von Chris Rupp und den SOPHISTen @rupp_requirements-engineering_2014. Es werden zunächst der aktuelle Arbeitsprozess und die Architektur benachbarter Systeme analysiert und dessen Probleme erkundet. Anschließend werden die Zielgruppen des neuen Systems ermittelt. Abschließend werden Ziele definiert.




== Architektur

=== Bestehende Tools & Anwendungen <andereAnwendungen>
-> Motivation warum wir das selber machen
-> wir brauchen eigene Lösung wegen Bastian
StudyPlan Admin kann Module & Studiengänge verwalten 
Bastian geht davon aus, dass das alles gefüllt ist 


=== Struktur des bestehenden Backends

=== Struktur der bestehenden Datenbank

=== Struktur der bestehenden Frontends 


== Interview mit Studiendekan
Da die Anforderungen sowie der aktuelle Arbeitsablauf noch unklar waren, musste eine Methode gefunden werden, um beides gründlich zu durchleuchten. Ein Interview hat den entscheidenden Vorteil, dass der Verlauf des Gesprächs individuell angepasst werden kann. Wenn sich neue Fragen ergeben, oder Fragen nicht ausreichend beantwortet wurden, kann im Interview direkt nachgefragt werden.@rupp_requirements-engineering_2014[Kapitel 6.3.3] 

Das Interview wurde mit dem derzeitigen Studiendekan #heine durchgeführt. Das Interview orientierte sich an den Vorschlägen der Sophisten. Bereits bei der Einladung zum Interview wurden einige der Vorschläge beachtet. Der Studiendekan konnte sich den Interviewort selbst auswählen und erhielt die geplanten Fragen vorab zur Einsicht. @rupp_requirements-engineering_2014[Seite 107-109]

Aus dem Interview ergaben sich zum einen die bereits vorgestellte Konkretisierung der Zielgruppen in @zielgruppen. Zum Anderen wurde der aktuelle Arbeitsprozess klar definiert, sowie dessen Schwachstellen aufgezeigt.

== Analyse des aktuellen Arbeitsprozesses und Identifikation von Schwachstellen



== Zielgruppen <zielgruppen>
Im Folgenden sollen die verschiedenen Zielgruppen eines Modulhandbuches ermittelt und definiert werden.

(https://www.sophist.de/fileadmin/user_upload/Bilder_zu_Seiten/Publikationen/RE6/Webinhalte_Buchteil_2/Webinhalt_Checkliste_Stakeholderklassen.pdf, Tabelle Kapitel 5.2.1)


=== Studierende
Der ECTS User-Guide @ects beschreibt, dass Modulhandbücher Studierenden vor und während ihrem Studium helfen. Studierende können mithilfe der Modulbeschreibungen verstehen, welche Inhalte in einem Modul gelernt werden und welche Voraussetzungen es gibt. Dadurch können Studierende einschätzen, ob die Wahl eines bestimmten Moduls – oder sogar eines gesamten Studienganges – für sie sinnvoll ist. Weiterhin können Studierende dank der Modulhandbücher zu jedem Modul den korrekten Ansprechpartner finden, einen Überblick über die zu erbringende Arbeitszeit erhalten, sowie Informationen zu den Prüfungsleistungen finden. 


=== Modulverantwortliche und Studiengangverantwortliche
Aus einem Interview mit dem Studiendekan geht hervor, dass es neben den Studierenden noch andere zu betrachtende Zielgruppen gibt. Für die Bearbeitung von Modulhandbüchern sind an der #hsh verschiedene Personengruppen zuständig. Zum einen gibt es den Studiendekan. Dieser ist für die Veröffentlichung des Dokumentes verantwortlich. Der Studiendekan ist nicht dafür zuständig, die Inhalte der einzelnen Modulbeschreibungen anzupassen. Für diese Anpassungen gibt es die Modulverantwortlichen. Jedes Modul hat eine Person, die die Informationen der Modulbeschreibung aktuell halten soll und gleichzeitig Ansprechpartner für Fragen ist.


== Use Cases <usecases>
Die Ergebnisse aus dem Interview werden mithilfe der Use–Case–Modellierung verwendet, um aufzuzeigen, welche Funktionen die einzelnen Akteure im neuen System verwenden können.


  "Sie können Use-Case-Beschreibungen als Ergänzung zu Use-Case-Diagrammen erstellen, etwa um jeden einzelnen Use-Case aus dem Diagramm genauer zu beleuchten. Use-Case Beschreibungen können aber auch ohne Diagramm für sich stehen."
@rupp_requirements-engineering_2014[s.~192]




== Zukünftiger Arbeitsprozess



== Anforderungen 
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

= Entwurf <entwurf>

== Struktur eines Modulhandbuches <structure>

== Datenbankschema / Klassendiagramm <dbschema>

== Benutzeroberflächen <UI>

=== Usability

=== Grundgerüst

=== Prototyp