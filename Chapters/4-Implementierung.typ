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

=== PrimeNG


=== Übersetzbarkeit

Für die Übersetzung der Website müssen zwei verschiedene Arten von Texten übersetzt werden. Die statischen Elemente der Website, wie zum Beispiel Button-Beschriftungen, oder Tabellenüberschriften ändern sich in der Regel nicht und stehen fest im Quellcode der Angular Anwendung. Die dynamischen Texte, wie zum Beispiel Modulnamen ändern sich abhängig vom angezeigten Modul und werden aus dem Backend empfangen. Diese beiden Arten an Texten werden auf verschiedene Weise übersetzt.


#heading("Statische Elemente", level: 4, numbering: none, outlined: false)

Für den Wechsel zwischen verschiedenen Sprachen gibt es in Angular bereits zahlreiche Möglichkeiten. Bereits in Angular eingebaut ist das Paket `@angular/localize`. Dieses bietet die Möglichkeit, die Angular Website für verschiedene Sprachen zu kompillieren. Mithilfe unterschiedlicher (Sub-) Domains oder Unterordner können die verschiedenen Sprachversionen dann bereitgestellt werden. Für den Wechsel der Sprache ist dann allerdings der Wechsel auf eine andere URL und ein damit verbundenes Neuladen der Website nötig. Ein weiterer Nachteil ist die hohe Komplexität der Einrichtung, sowie die mangelnde Flexibilität. Die entstehenden Übersetzungsdateien spiegeln die Struktur der HTML-Seiten wider, was bedeutet, dass bei Änderungen der HTML-Struktur auch die Übersetzungsdatei angepasst werden muss. Auch das Anlegen der Übersetzungsdatei ist dadurch nicht trivial. @angularInternationalizationExample

Ein simplerer Ansatz könnte die Nutzung von Key-Value-Paaren sein. Hierbei wird ein Key in die HTML-Seite geschrieben. Es gibt pro Sprache eine Übersetzungsdatei, die zu jedem Key einen Value zur Verfügung stellt, der die korrekte Übersetzung enthält. Ein Framework tauscht dann zur Laufzeit die Keys durch die gewünschten Values aus. Zur Auswahl eines geeigneten Frameworks wurden verschiedene Metriken betrachtet. Das genutzte Framework soll einfach zu nutzen sein, mit Key-Value-Dateien arbeiten können und eine gute Dokumentation haben. Auch sollten die Downloadzahlen auf NPM hoch genug sein, da ansonsten fraglich ist, ob das Paket die beste Wahl ist. Diese Anforderungen wurden von `@ngx-translate/core` und von `@jsverse/transloco` (früher unter `@ngneat/transloco` bekannt) erfüllt. Da `@ngx-translate/core` jedoch nicht mehr weiterentwickelt wird, wurde für dieses System `@jsverse/transloco` genutzt.

Um nun die statischen Texte in verschiedenen Sprachen anzubieten, wurden die Dateien en.json und de.json in den Assets-Ordner des Frontends gelegt. Die Angular-Konfiguration wurde erweitert, sodass beim Kompillieren die Übersetzungsdateien in den Build-Ordner kopiert werden, sodass diese später auf dem Webserver bereitliegen. Beim Laden der Anwendung stellt Transloco nun automatisch sicher, dass die benötigte Sprachdatei per HTTP-Request vom Webserver geladen wird. Anschließend mussten nur noch die .html-Dateien angepasst werden, damit dort auch die Texte aus den Übersetzungsdateien geladen werden. Hierzu wurde ein neues Element zu jeder HTML Seite hinzugefügt: `<ng-container *transloco="let t; prefix:'faculties'">`. Durch den optionalen Prefix ist es möglich, Übersetzungen zu gruppieren. Um jetzt beispielsweise das Wort "Fakultätsübersicht" auszugeben, muss `{faculties: {overview: Fakultätsübersicht}}` zu de.json hinzugefügt werden. Anschließend kann folgendes Element genutzt werden: `<span>{{t('overview')}}</span>`. 



#heading("Dynamische Elemente", level: 4, numbering: none, outlined: false)
Damit die dynamischen Elemente übersetzt werden, benötigt das Backend die gewünschte Sprache. Diese wird im Header des GET-Requests übermittelt. Steht im Header `Language=DE`, werden deutsche Texte zurückgegeben. Damit nicht jeder HTTP-Request im Frontend manuell mit dem Header gefüllt werden muss, wird ein HTTPInterceptor genutzt (@languageInterceptor). Dieser erhält die aktuell gesetzte Sprache aus dem LanguageService (Zeile 5). Falls sich die dort eingestellte Sprache ändert, wird dies über ein BehaviourSubject kommuniziert und im LanguageInterceptor aktualisiert (Zeile 7). In der Methode intercept wird dann der Header auf die aktuell eingestellte Sprache gesetzt. Dies passiert nicht, falls der ursprüngliche Request bereits einen Language-Header hat, damit das Verhalten übersteuert werden kann. Dies ist beispielsweise für die Bearbeitungsmaske eines Modules hilfreich, in der die englische Modulbeschreibung bearbeitet werden soll, ohne dafür die gesamte UI auf Englisch stellen zu müssen. 

In der `ApplicationConfig` der Angular Anwendung kann nun mithilfe einer Option konfiguriert werden, dass als HTTPInterceptor die neue Klasse LanguageInterceptor genutzt wird. Somit werden alle Requests mit der Sprache im Header erweitert.

Damit sich beim Wechsel der Sprache auch alle dynamischen Texte ändern, ist ein erneuter Aufruf der API notwendig. Auch hierzu wird ein BehaviourSubject genutzt. Das BehaviourSubject kommt aus RxJS. Es folgt dem Observer-Pattern und benachrichtigt beim Wechsel der Sprache alle Observer. Somit können beim Sprachwechsel die dynamischen Informationen erneut aus dem Backend angefragt und in der Oberfläche dargestellt werden.


#codeFigure("language.interceptor.ts", <languageInterceptor>, "languageInterceptor")




=== UI: Module anlegen
=== UI: Module anzeigen 
==== Website
==== PDF
=== UI: Module bearbeiten

== Dokumentation <createDocumentation>

