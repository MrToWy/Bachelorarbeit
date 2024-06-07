#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *

= Implementierung <implementierung>
Nachdem in @entwurf das System geplant wurde, soll nun in diesem Kapitel das System erstellt werden. Zunächst wird das Backend vorbereitet. Hierzu wird in @schema als erstes die Datenbank an das neue Schema angepasst, um im Anschluss die geplanten Endpunkte implementieren zu können. Sobald das Backend vollständig ist, kann das Frontend die benötigten Daten abrufen. Deshalb wird erst im zweiten Schritt dann in @createFrontend das Frontend erstellt. In @createDocumentation ist abschließend beschrieben, wie das System dokumentiert wurde. 

== Backend <createBackend>
Das Backend wird im folgenden auch als API bezeichnet und greift auf verschiedene andere Komponenten zu (@architectureDiagram). Es gibt eine Datenbank, in der die Informationen zu den Modulen, Usern und die Änderungshistorie gespeichert werden. Außerdem gibt es die API selbst, die Daten aus der Datenbank lädt und mithilfe von HTTP-Endpunkten an das Frontend weitergibt. Zuletzt gibt es zwei Python-Skripte und einen Docker-Container, welche aus der Datenbank für die einzelnen Studiengänge die Modulhandbücher im PDF-Format generieren. In den folgenden Unterabschnitten ist die Implementierung der genannten Komponenten beschrieben.

#imageFigure(<architectureDiagram>, "Architektur.png", "Komponenten des Systems")

=== Datenbank <schema>

Im ersten Schritt wurde das vorhandene Datenbankschema an das in @dbschema erstellte Schema angeglichen. 

Hierzu musste die in @dbstructure gezeigte schema.prisma-Datei bearbeitet werden. In der Prisma-Datei entspricht ein wie in @moduletable gezeigter Block einer Tabelle in der Datenbank. Einzelne Zeilen innerhalb des Blocks ensprechen Spalten in der Tabelle. Neben der Id-Zeile in @moduletable ist zu sehen, wie eine selbstständig hochzählende Zahl möglich ist. Außerdem können in der Schema-Datei Relationen zwischen Tabellen definiert werden, indem hinter eine entsprechende Zeile \@relation geschrieben wird. Hierbei ist zubeachten, dass immer in beiden Tabellen eine \@relation definiert werden muss. (siehe @moduleprismanew). Mithilfe von Konsolenbefehlen kann dann die Prisma-Datei auf die Datenbank angewendet werden.

Neben neuen Tabellen wie zum Beispiel der Tabellen für Fakultät und Abteilung gab es einen erhöhten Arbeitsaufwand beim Hinzufügen der übersetzbaren Texte. Die in @dbschema geplante Art, die Übersetzungen abzuspeichern erwies sich als unpraktisch. Zwar konnte das Datenbankschema noch ohne viel Aufwand erstellt werden (@moduleprismanew), jedoch führten die verschiedenen Ids (nameId, descriptionId) zu einem Problem. Damit ein Modul im Frontend dargestellt werden kann, muss mit der bisherigen Planung für jedes einzelne übersetzte Feld ein Join auf die Tabelle "TranslationKey" und auf die Tabelle "Translation" gemacht werden, um den gewünschten Text zu erhalten. Dies führt bereits bei der Abfrage eines einzelnen Modules zu vielen Joins und einer recht komplizierten Codestruktur.

#codeFigure("Beispiel für Relations-Felder", <moduleprismanew>, "modulePrismaNew")

Um die komplizierten Joins und den sich daraus ergebenen komplizierten Quellcode zu vermeiden, wurde die Datenstruktur der übersetzten Texte leicht verändert. Pro Tabelle, die zu übersetzende Felder beinhaltet wurde eine weitere Tabelle erstellt, die die Texte enthält (siehe @newDbSchema). Somit sind nun nicht mehr pro übersetztem Feld zwei Joins erforderlich, sondern nur noch pro Tabelle ein Join.

#imageFigure(<newDbSchema>, "newTransl.png", "Beispiel: Übersetzung eines Modules", width: 8em)

Bei dem Prozess, die vorhandene Datenstruktur zu ändern, gingen die Test-Daten verloren. Es wurde kein Aufwand investiert, um die Migration verlustfrei zu gestalten. Nach Fertigstellung der Datenstruktur sollen die vom Studiendekan ermittelten Daten in die Datenbank eingesetzt werden, da diese auf einem neueren Stand sind, bereits geprüft wurden und vollständig sein sollten.

Die Datenübernahme wurde mithilfe von Python umgesetzt. Bei der Erstellung des Skripts wurde darauf geachtet, dass es bei jeder Ausführung zunächst die neue Datenbank leert, um anschließend die Daten von der alten Datenbank in die neue Datenbank zu kopieren. 


=== HTTP-Endpunkte <createEndpoints>

Nachdem die Datenbank vorbereitet war, konnten nun die benötigten Endpunkte im Backend angelegt werden. 

Hierzu wurden zunächst Controller-Klassen für die verschiedenen Entitäten angelegt. Beispielsweise wird ein DegreeController benötigt (@degreeController), um die benötigten Endpunkte für Studiengänge bereitzustellen. Innerhalb der Controller wurde anschließend für jeden benötigten Endpunkt eine Methode erstellt und mithilfe von Dekoratoren näher beschrieben. @ControllersDocumentationNestJS
Der `@Controller`-Dekorator sorgt dafür, dass NestJs die Klasse als Controller identifiert und entsprechend die enthaltenen Endpunkte bereitstellt. Außerdem ist als Parameter angegeben, unter welchem Pfad die Endpunkte erreichbar sind (hier: /degrees).
Der `@ApiTags`-Dekorator sorgt dafür, dass die Endpunkte in der Weboberfläche der API gruppiert in der Gruppe "Degrees" dargestellt werden. Weiterhin werden die Methoden für die Endpunkte mit einem Dekorator versehen, der die HTTP-Methode angibt, die genutzt werden muss, um den Endpunkt aufzurufen. Wenn der Endpunkt `/degrees` per GET-Request aufgerufen wird, wird also das Ergebnis der findAll-Methode zurückgegeben. Wenn der Endpunkt `/degrees/5` aufgerufen wird, wird das Ergebnis der findOne-Methode zurückgegeben. Die findOne-Methode erhält außerdem weitere Parameter, die auch in vielen anderen Methoden im Backend ähnlich genutzt werden. Der erste Parameter enthält die Id aus dem Pfad der Anfrage (im Beispiel /degrees/5, wäre das die 5). Der zweite Parameter enthält ein Request-Objekt. Dieses wird genutzt, um die in dem Request übergebenen Header auszulesen. Im aktuellen Beispiel wird die angefragte Sprache ausgelesen, um vom DegreeService Informationen in der Sprache des Benutzers zu erhalten.

Über den Constructor werden per Dependency Injection @DependencyInjectionAngular die benötigten Services übergeben. Das Framework nest.js sorgt dafür, dass die Services einmalig instanziiert werden. 

#codeFigure("degree.controller.ts (Auszug)", <degreeController>, "degree.controller")


Des Weiteren ist es wichtig, zwischen öffentlichen und privaten Endpunkten zu unterscheiden. Damit User im Frontend auch ohne Anmeldung die Module ansehen können, müssen manche Endpunkte ohne Authentisierung erreichbar sein. Hierzu wurde ein eigener Dekorator (@publicDecorator) erstellt. Dieser kann einfach über einen Endpunkt geschrieben werden, um diesen als öffentlich zu markieren (@moduleController). Damit dies funktioniert, musste zusätzlich der AuthGuard durch eine eigene Implementierung (@authGuard) ersetzt werden. Diese neue Implmentierung überprüft, ob in den Metadaten "isPublic" steht. Wenn dies der Fall ist, kann die Anfrage mit `return true` genehmigt werden. Falls diese Metadaten nicht gesetzt sind, wird die ursprüngliche Implementierung von canActivate (@authGuard, Zeile 14) aufgerufen, um zu überprüfen, ob ein gültiger Token mitgesendet wurde. 

#codeFigure("public.decorator.ts", <publicDecorator>, "publicDecorator")

#codeFigure("module.controller.ts", <moduleController>, "getModule")

#codeFigure("jwt-auth.guard.ts", <authGuard>, "authGuard")





Für die Generierung der PDF-Datei (@PDF), wird ein Python-Skript ausgeführt (@pythonScript). Da dies eine längere Laufzeit hat, meldet der Endpunkt zunächst den Status 202-Accepted zurück, und nennt eine Id. Das Frontend kann mithilfe der Id das fertige PDF abrufen. Solange das PDF noch nicht bereit steht, meldet das Backend einen Status 404-Not Found zurück. @restUndHTTP[Abschnitt 13.1]


=== PDFs generieren <pythonScript>

Das Generieren einer Modulbeschreibung in Form einer PDF-Datei verläuft in mehreren Teilschritten:

1. Die Studiengangsverantwortliche Person (User) fragt neue PDF Version an
2. Das Backend erstellt aus den vorliegenden Informationen eine .tex-Datei und veröffentlicht einen Auftrag zur Kompilierung
3. Ein Kompilierungs-Server nimmt den Auftrag an und ruft die .tex-Datei aus dem Backend ab 
4. Der Kompilierungs-Server kompiliert die .tex-Datei zu einer PDF-Datei und gibt diese ans Backend zurück
5. Das Backend meldet das Ergebnis an den User zurück
6. Der User prüft das Ergebnis und gibt es frei
7. Die neue PDF Version steht bereit

Die Schritte 2 bis 5 werden im Folgenden näher beschrieben.

#heading("Generierung der .tex-Datei", level: 4, numbering: none, outlined: false)
Die Grundlage für die Generierung der .tex-Datei bildet ein Python-Skript, welches von #heine bereitgestellt wurde. Dieses Script wurde im Rahmen dieser Arbeit an die veränderte Datenstruktur angepasst. Außerdem wurde das Skript erweitert, sodass es bei der Ausführung nicht für alle Studiengänge eine .tex-Datei generiert wird, sondern dass ein Studiengang in einer Sprache auswählbar ist.
Das python-Script wird ausgeführt, sobald ein berechtigter User im Frontend die Generierung eines neuen PDFs beauftragt.

#heading("Generierung der .pdf-Datei", level: 4, numbering: none, outlined: false)
Für die erfolgreiche Kompilierung der .tex-Datei muss die Server-Umgebung konfiguriert werden. Zusätzlich zur Möglichkeit, Latex kompilieren zu können, müssen die von der .tex-Datei benötigten Pakete bereitstehen. Um diesen Aufwand zu verringern wird ein Docker-Image eingesetzt, welches es ermöglicht, ohne weiteren Konfigurationsaufwand per HTTP-Request eine .tex-Datei zu kompilieren @YtoTechLatexonhttp2024.

Außerdem wurde ein weiteres python-Skript erstellt, welches einen Kompilierungs-Server implementiert. Das Skript prüft in regelmäßigen Abständen, ob in der API ein Auftrag zur Erstellung einer neuen PDF-Datei vorliegt. Erhält er dabei einen Auftrag, markiert der Server diesen als "laufend", damit dies auch im Frontend ersichtlich ist und damit kein anderer Server den Auftrag übernimmt. Anschließend ruft der Server die .tex-Datei aus dem Backend ab und übergibt sie an den Docker-Container. Der Docker-Container erstellt nun die PDF-Datei und gibt diese an den Server zurück. Der Server übermittelt das Ergebnis zurück an das Backend. @NestJSStreamingFiles Die Erstellung des PDFs ist entkoppelt vom Backend. Somit können beispielsweise mehrere Server betrieben werden, um die PDF-Erstellung zu parallelisieren. Auch können die Server unterschiedlich implementiert werden, sodass auch andere Dateiformate umsetzbar wären. Zukünftige Implementierungen könnten beispielsweise Word-Dokumente in ein PDF-Dokument umwandeln, oder Typst-Code in ein PDF-Dokument kompilieren. Beim Hinzufügen weiterer Kompilierungs-Server muss das Backend nicht angepasst werden, da dieses lediglich die Aufträge anbietet und die Aufträge nicht selbst an konkrete Server zuweist.



== Frontend <createFrontend>

=== Komponenten
Das Frontend ist auf zahlreiche möglichst kleine Komponenten aufgeteilt. Jede Komponente hat genau eine Aufgabe. 


=== PrimeNG
Ein UI-Framework kann bei der Implementierung des Frontends unterstützen. Vom Framework angebotene vorgefertigte Komponenten müssen nicht selbst implementiert werden. Zunächst wurden die Frameworks `@ng-bootstrap/ng-bootstrap` @AngularPoweredBootstrap und `primeng` @PrimeNGAngularUI verglichen. Beide Frameworks haben hohe Downloadzahlen und eine gute Dokumentation. Da PrimeNG jedoch weitaus mehr Komponenten anbietet, wird in diesem Projekt PrimeNG verwendet. Dank der Nutzung von PrimeNG ist die Implementierung der verschiedenen Tabellen und Formularen weitaus effizienter. Außerdem sieht das System insgesamt einheitlich und modern aus, weil alle PrimeNG-Komponenten dem gleichen Theme folgen. @PrimeNGAngularUI     


=== Übersetzbarkeit

Damit jede Komponente weiß, welche Sprache gerade dargestellt werden soll, wird ein Service genutzt (@languageService). Dieser kann per Dependency Injection @DependencyInjectionAngular im Konstruktor einer beliebigen Komponente genutzt werden. Wenn in der Topbar (@grundgerüst) eine andere Sprache ausgewählt wird, wird die Eigenschaft `languageCode` im LanguageService verändert (`this.languageService.languageCode = selectedLanguageCode;`). 

Der LanguageService hat eine Methode `getLanguages`, mit der an verschiedenen Stellen in der Anwendung angezeigt werden kann, welche Sprachen zur Auswahl stehen. Außerdem sind Getter und Setter für die Eigenschaft `languageCode` implementiert. Im Setter wird die ausgewählte Sprache in den LocalStorage geschrieben, damit die Benutzer der Website nicht bei jedem Besuch erneut ihre Sprache auswählen müssen. Außerdem wird die neuausgewählte Sprache an das `languageSubject` weitergegeben. Das `languageSubject` ist ein BehaviourSubject aus der Erweiterungsbibliothek RxJS @RxJSBehaviorSubject. Nach dem Observer-Pattern-Prinzip können andere Komponenten und Services das languageSubject beobachten und erhalten im Falle einer Veränderung eine Benachrichtigung. Somit können beim Wechsel der Sprache die neuen Texte geladen werden.

#codeFigure("language.service.ts", <languageService>, "languageService")


Für die Übersetzung der Website müssen zwei verschiedene Arten von Texten übersetzt werden. Die statischen Elemente der Website, wie zum Beispiel Button-Beschriftungen, oder Tabellenüberschriften ändern sich in der Regel nicht und stehen fest im Quellcode der Angular Anwendung. Die dynamischen Texte, wie zum Beispiel Modulnamen ändern sich abhängig vom angezeigten Modul und werden aus dem Backend empfangen. Diese beiden Arten an Texten werden auf verschiedene Weise übersetzt.


#heading("Statische Elemente", level: 4, numbering: none, outlined: false)

Für den Wechsel zwischen verschiedenen Sprachen gibt es in Angular bereits zahlreiche Möglichkeiten. Bereits in Angular eingebaut ist das Paket `@angular/localize` @AngularInternationalization. Dieses bietet die Möglichkeit, die Angular Website für verschiedene Sprachen zu kompilieren. Mithilfe unterschiedlicher (Sub-) Domains oder Unterordner können die verschiedenen Sprachversionen dann bereitgestellt werden. Für den Wechsel der Sprache ist dann allerdings der Wechsel auf eine andere URL und ein damit verbundenes Neuladen der Website nötig. Ein weiterer Nachteil ist die hohe Komplexität der Einrichtung, sowie die mangelnde Flexibilität. Die entstehenden Übersetzungsdateien spiegeln die Struktur der HTML-Seiten wider, was bedeutet, dass bei Änderungen der HTML-Struktur auch die Übersetzungsdatei angepasst werden muss. Auch das Anlegen der Übersetzungsdatei ist dadurch nicht trivial. @angularInternationalizationExample

Ein simplerer Ansatz könnte die Nutzung von Key-Value-Paaren sein. Hierbei wird ein Key in die HTML-Seite geschrieben. Es gibt pro Sprache eine Übersetzungsdatei, die zu jedem Key einen Value zur Verfügung stellt, der die korrekte Übersetzung enthält. Ein Framework tauscht dann zur Laufzeit die Keys durch die gewünschten Values aus. Zur Auswahl eines geeigneten Frameworks wurden verschiedene Metriken betrachtet. Das genutzte Framework soll einfach zu nutzen sein, mit Key-Value-Dateien arbeiten können und eine gute Dokumentation haben. Auch sollten die Downloadzahlen auf NPM hoch genug sein, da ansonsten fraglich ist, ob das Paket die beste Wahl ist. Geringe Downloadzahlen können eine geringe Verbreitung bedeuten, was unter anderem dazu führen kann, dass das Paket keinen langfristigen Support erhält. Diese Anforderungen wurden von `@ngx-translate/core`@NgxtranslateCore2024 und von `@jsverse/transloco` @TranslocoAngularI18n (früher unter `@ngneat/transloco` bekannt @NgneatTransloco2023) erfüllt. Da `@ngx-translate/core` jedoch nicht mehr weiterentwickelt wird, wurde für dieses System `@jsverse/transloco` genutzt.

Um nun die statischen Texte in verschiedenen Sprachen anzubieten, wurden die Dateien en.json und de.json in den Assets-Ordner des Frontends gelegt. Die Angular-Konfiguration wurde erweitert, sodass beim Kompilieren die Übersetzungsdateien in den Build-Ordner kopiert werden, sodass diese später auf dem Webserver bereitliegen. Beim Laden der Anwendung stellt Transloco automatisch sicher, dass die benötigte Sprachdatei per HTTP-Request vom Webserver geladen wird. Anschließend mussten nur noch die .html-Dateien angepasst werden, damit dort auch die Texte aus den Übersetzungsdateien geladen werden. Hierzu wurde ein neues Element zu jeder HTML-Seite hinzugefügt: `<ng-container *transloco="let t; prefix:'faculties'">`. Durch das optionale Präfix ist es möglich, Übersetzungen zu gruppieren. Um jetzt beispielsweise das Wort "Fakultätsübersicht" auszugeben, muss `faculties: {overview: Fakultätsübersicht}` zu de.json hinzugefügt werden. Anschließend kann folgendes Element genutzt werden: `<span>{{t('overview')}}</span>`. @TranslocoAngularI18n



#heading("Dynamische Elemente", level: 4, numbering: none, outlined: false)
Damit die dynamischen Elemente übersetzt werden, benötigt das Backend die gewünschte Sprache. Diese wird im Header des GET-Requests übermittelt. Steht im Header `Language=DE`, werden deutsche Texte zurückgegeben. Damit nicht jeder HTTP-Request im Frontend manuell mit dem Header gefüllt werden muss, wird ein HTTPInterceptor @AngularHTTPClient genutzt (@languageInterceptor). Dieser erhält die aktuell gesetzte Sprache aus dem LanguageService (Zeile 5). Falls sich die dort eingestellte Sprache ändert, wird dies über ein BehaviourSubject kommuniziert und im LanguageInterceptor aktualisiert (Zeile 7). In der Methode intercept wird dann der Header auf die aktuell eingestellte Sprache gesetzt. Dies passiert nicht, falls der ursprüngliche Request bereits einen Language-Header hat, damit das Verhalten übersteuert werden kann. Dies ist beispielsweise für die Bearbeitungsmaske eines Modules hilfreich, in der die englische Modulbeschreibung bearbeitet werden soll, ohne dafür die gesamte UI auf Englisch stellen zu müssen. 

In der `ApplicationConfig` der Angular Anwendung kann nun mithilfe einer Option konfiguriert werden, dass als HTTPInterceptor die neue Klasse LanguageInterceptor genutzt wird. Somit werden alle Requests mit der Sprache im Header erweitert.

Damit sich beim Wechsel der Sprache auch alle dynamischen Texte ändern, ist ein erneuter Aufruf der API notwendig. Hierzu wird das BehaviourSubject aus dem LanguageService (@languageService) genutzt. Somit können beim Sprachwechsel die dynamischen Informationen erneut aus dem Backend angefragt und in der Oberfläche dargestellt werden.


#codeFigure("language.interceptor.ts", <languageInterceptor>, "languageInterceptor")




=== UI: Module anlegen
=== UI: Module anzeigen 
==== Website
==== PDF
=== UI: Module bearbeiten

== Dokumentation <createDocumentation>

