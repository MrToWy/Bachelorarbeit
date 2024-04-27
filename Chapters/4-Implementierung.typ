#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *

= Implementierung <implementierung>
== Backend aus Datenbankschema erstellen

=== Schema vorbereiten <schema>
Im ersten Schritt wurde das vorhandene Datenbankschema an das in @dbschema erstellte Schema angeglichen. Neben neuen Tabellen wie zum Beispiel der Tabellen für Fakultät und Abteilung gab es einen erhöhten Arbeitsaufwand beim Hinzufügen der übersetzbaren Texte. Hierbei war es leider nicht ausreichend, die Verweise auf Einträge in der Tabelle "TranslationKey" zu setzen (Zeile 3 und 4 in @factultyPrismaCode), sondern es musste auch zu jedem übersetzten Text ein Relations-Feld in der Tabelle  "TranslationKey" hinterlegt werden (Zeile 4 in @relationPrismaCode).

#codeFigure("Faculty-Tabelle", <factultyPrismaCode>, "facultyPrisma")

#codeFigure("TranslationKey-Tabelle", <relationPrismaCode>, "relationPrisma")

Glücklicherweise kann das von Prisma benötigte Relations-Feld mithilfe des Befehls `prisma format` automatisch generiert werden. Das funktioniert allerdings nur, wenn die Tabelle einen einzigen Verweis zur TranslationKey-Tabelle hat. Wenn das nicht der Fall ist, müssen die Relations-Felder manuell gesetzt werden. Zusätzlich muss jede Relation dann einen eigenen Namen erhalten, damit Prisma die Zuweisung versteht. Dies ist beispielsweise für die Modul-Tabelle relevant, die viele übersetzte Felder besitzt.  

#codeFigure("Beispiel für Relations-Felder", <moduleprismanew>, "modulePrismaNew")

Bei dem Prozess, die vorhandene Datenstruktur zu ändern, gingen die Test-Daten verloren. Es wurde kein Aufwand investiert, um die Migration verlustfrei zu gestalten. Nach Fertigstellung der Datenstruktur sollen die vom Studiendekan ermittelten Daten in die Datenbank eingesetzt werden, da diese bereits geprüft sind und vollständig sein sollten.

=== Endpoints erstellen
Nachdem die Datenbank vorbereitet war, konnten nun die benötigten Endpoints im Backend angelegt werden. Hierbei war es wichtig, 


Die Eingabeelemente im Frontend mithilfe eines Dropdowns fertige Texte anbieten. 
Dank der zuvor erstellen Relations-Felder (@schema), ist es einfach, hierfür Endpoints zu erstellen. Wird beispielsweise ein Vorschlag für den Eintrag Prüfungsleistungen (@exam) benötigt, kann einfach auf das Relations-Feld  `TranslationKey.moduleExams` geschaut werden, welches alle Einträge aus dem Feld Exam in der Tabelle Module vereint.

== UI: Module anlegen
== UI: Module anzeigen 
=== Website
=== PDF
== UI: Module bearbeiten

== Dokumentation

