#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *

= Implementierung <implementierung>
Nachdem in @entwurf das System geplant wurde, sollen nun in diesem Kapitel das gesamte System erstellt werden. Zunächst wird das Backend vorbereitet. Hierzu wird in @createBackend als erstes die Datenbank an das neue Schema angepasst, um im Anschluss die geplanten Endpunkte implementieren zu können. Sobald das Backend vollständig ist, kann das Frontend die benötigten Daten abrufen. Deshalb wird erst im zweiten Schritt dann in @createFrontend das Frontend erstellt. In @createDocumentation ist abschließend beschrieben, wie das System dokumentiert wurde. 

== Backend <createBackend>
Das Backend besteht aus drei Komponenten. Es gibt eine Datenbank, in der die Informationen zu den Modulen, Usern und die Änderungshistorie gespeichert werden. Außerdem gibt es die Anwendung, die Daten aus der Datenbank lädt und mithilfe von HTTP-Endpunkten an das Frontend weitergibt. Zuletzt gibt es noch ein Python-Skript, welches aus der Datenbank für die einzelnen Studiengänge die Modulhandbücher im PDF-Format generiert. In den folgenden Unterabschnitten ist die Implementierung der drei genannten Komponenten beschrieben.

=== Datenbank <schema>

Im ersten Schritt wurde das vorhandene Datenbankschema an das in @dbschema erstellte Schema angeglichen. Neben neuen Tabellen wie zum Beispiel der Tabellen für Fakultät und Abteilung gab es einen erhöhten Arbeitsaufwand beim Hinzufügen der übersetzbaren Texte. Hierbei war es leider nicht ausreichend, die Verweise auf Einträge in der Tabelle "TranslationKey" zu setzen (Zeile 3 und 4 in @factultyPrismaCode), sondern es musste auch zu jedem übersetzten Text ein Relations-Feld in der Tabelle  "TranslationKey" hinterlegt werden (Zeile 4 in @relationPrismaCode).

#codeFigure("Faculty-Tabelle", <factultyPrismaCode>, "facultyPrisma")

#codeFigure("TranslationKey-Tabelle", <relationPrismaCode>, "relationPrisma")

Glücklicherweise kann das von Prisma benötigte Relations-Feld mithilfe des Befehls `prisma format` automatisch generiert werden. Das funktioniert allerdings nur, wenn die Tabelle einen einzigen Verweis zur TranslationKey-Tabelle hat. Wenn das nicht der Fall ist, müssen die Relations-Felder manuell gesetzt werden. Zusätzlich muss jede Relation dann einen eigenen Namen erhalten, damit Prisma die Zuweisung versteht. Dies ist beispielsweise für die Modul-Tabelle relevant, die viele übersetzte Felder besitzt.  

#codeFigure("Beispiel für Relations-Felder", <moduleprismanew>, "modulePrismaNew")

Bei dem Prozess, die vorhandene Datenstruktur zu ändern, gingen die Test-Daten verloren. Es wurde kein Aufwand investiert, um die Migration verlustfrei zu gestalten. Nach Fertigstellung der Datenstruktur sollen die vom Studiendekan ermittelten Daten in die Datenbank eingesetzt werden, da diese auf einem neueren Stand sind, bereits geprüft wurden und vollständig sein sollten.

Die Datenübernahme wurde mithilfe von Python umgesetzt. Bei der Erstellung des Skripts wurde darauf geachtet, dass es bei jeder Ausführung zunächst die neue Datenbank leert, um anschließend die Daten von der alten Datenbank in die neue Datenbank zu kopieren. Die größte Hürde war hier die Übersetzbarkeit. In der ursprünglichen Datenstruktur war die Übersetzbarkeit anders umgesetzt, sodass das Kopieren mehrsprachiger Texte anspruchsvoller war, als das Kopieren einfacher Zahlenwerte.


=== HTTP-Endpunkte <createEndpoints>

Nachdem die Datenbank vorbereitet war, konnten nun die benötigten Endpoints im Backend angelegt werden. Hierbei war es wichtig, 


Die Eingabeelemente im Frontend mithilfe eines Dropdowns fertige Texte anbieten. 
Dank der zuvor erstellen Relations-Felder (@schema), ist es einfach, hierfür Endpoints zu erstellen. Wird beispielsweise ein Vorschlag für den Eintrag Prüfungsleistungen (@exam) benötigt, kann einfach auf das Relations-Feld  `TranslationKey.moduleExams` geschaut werden, welches alle Einträge aus dem Feld Exam in der Tabelle Module vereint.

Für die Generierung der PDF-Datei (@PDF), wird ein Python-Skript ausgeführt (@pythonScript). Da dies eine längere Laufzeit hat, meldet der Endpunkt zunächst den Status 202-Accepted zurück, und nennt eine Id. Das Frontend kann mithilfe der Id das fertige PDF abrufen. Solange das PDF noch nicht bereit steht, meldet das Backend einen Status 404-Not Found zurück. @restUndHTTP[Abschnitt 13.1]


=== PDFs generieren <pythonScript>




== Frontend <createFrontend>
=== UI: Module anlegen
=== UI: Module anzeigen 
==== Website
==== PDF
=== UI: Module bearbeiten

== Dokumentation <createDocumentation>

