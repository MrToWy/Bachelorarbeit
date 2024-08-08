#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *



= Implementierung <implementierung>
Nachdem in @entwurf das System geplant wurde, soll nun in diesem Kapitel das System erstellt werden. Zunächst wird das Backend vorbereitet. Hierzu wird in @schema als erstes die Datenbank an das neue Schema angepasst, um im Anschluss die geplanten Endpunkte implementieren zu können. Sobald das Backend vollständig ist, kann das Frontend die benötigten Daten abrufen. Deshalb wird erst im zweiten Schritt dann in @createFrontend das Frontend erstellt. In @createDocumentation ist abschließend beschrieben, wie das System dokumentiert wurde. 

== Backend <createBackend>
Das Backend wird im Folgenden auch als API bezeichnet und greift auf verschiedene andere Komponenten zu (@architectureDiagram). Es gibt eine Datenbank, in der die Informationen zu den Modulen, Usern und die Änderungshistorie gespeichert werden. Außerdem gibt es die API selbst, die Daten aus der Datenbank lädt und mithilfe von HTTP-Endpunkten an das Frontend weitergibt. Zuletzt gibt es zwei Python-Skripte und einen Docker-Container, welche aus der Datenbank für die einzelnen Studiengänge die Modulhandbücher im PDF-Format generieren. In den folgenden Unterabschnitten ist die Implementierung der genannten Komponenten beschrieben.

#imageFigure(<architectureDiagram>, "Architektur.png", "Komponenten des Systems")

#block(breakable: false)[
=== Datenbank <schema>
Im ersten Schritt wurde das vorhandene Datenbankschema an das in @dbschema erstellte Schema angeglichen. 

Hierzu musste die in @dbstructure gezeigte schema.prisma-Datei bearbeitet werden. In der Prisma-Datei entspricht ein wie in @moduletable gezeigter Block einer Tabelle in der Datenbank. Einzelne Zeilen innerhalb des Blocks ensprechen Spalten in der Tabelle. Neben der Id-Zeile in @moduletable ist zu sehen, wie eine selbstständig hochzählende Zahl möglich ist. Außerdem können in der Prisma-Datei Relationen zwischen Tabellen definiert werden, indem hinter eine entsprechende Zeile \@relation geschrieben wird. @RelationsReferencePrisma Hierbei ist zubeachten, dass immer in beiden Tabellen eine \@relation definiert werden muss. (siehe @moduleprismanew). Mithilfe von Konsolenbefehlen kann dann die Prisma-Datei auf die Datenbank angewendet werden.@PrismaSchemaOverview
]

#codeFigure("Beispiel für Relations-Felder", <moduleprismanew>, "modulePrismaNew")



Bei dem Prozess, die vorhandene Datenstruktur zu ändern, gingen die Test-Daten verloren. Es wurde kein Aufwand investiert, um die Migration verlustfrei zu gestalten. Nach Fertigstellung der Datenstruktur sollen die vom Studiendekan ermittelten Daten in die Datenbank eingesetzt werden, da diese auf einem neueren Stand sind, bereits geprüft wurden und vollständig sein sollten.

Die Datenübernahme wurde mithilfe von Python umgesetzt. Bei der Erstellung des Skripts wurde darauf geachtet, dass es bei jeder Ausführung zunächst die neue Datenbank leert, um anschließend die Daten von der alten Datenbank in die neue Datenbank zu kopieren. Anschließend wurden die Daten der verschiedenen Tabellen eingelesen, auf das neue Format konvertiert und in die neue Datenbank eingesetzt. Die hierzu genutzten Insert-Statements mussten aufgrund der Abhängigkeiten zwischen den verschiedenen Tabellen in einer bestimmten Reihenfolge erfolgen. Weil beispielsweise jedes Modul einem Studiengang zugewiesen wird, müssen erst alle Studiengänge in die Datenbank eingesetzt werden, bevor deren Module eingesetzt werden können.  


=== HTTP-Endpunkte <createEndpoints>

Nachdem die Datenbank vorbereitet war, konnten nun die benötigten Endpunkte im Backend angelegt werden. 

Hierzu wurden zunächst Controller-Klassen für die verschiedenen Entitäten angelegt. Beispielsweise wird ein DegreeController benötigt (@degreeController), um die benötigten #link(<degreesEndpoint>)[Endpunkte für Studiengänge] bereitzustellen. Innerhalb der Controller wurde anschließend für jeden benötigten Endpunkt eine Methode erstellt und mithilfe von Dekoratoren näher beschrieben. @ControllersDocumentationNestJS
Der `@Controller`-Dekorator sorgt dafür, dass NestJs die Klasse als Controller identifiert und entsprechend die enthaltenen Endpunkte bereitstellt. Außerdem ist als Parameter angegeben, unter welchem Pfad die Endpunkte erreichbar sind (hier: /degrees).
Der `@ApiTags`-Dekorator sorgt dafür, dass die Endpunkte in der Weboberfläche der API gruppiert in der Gruppe "Degrees" dargestellt werden. Weiterhin werden die Methoden für die Endpunkte mit einem Dekorator versehen, der die HTTP-Methode angibt, die genutzt werden muss, um den Endpunkt aufzurufen. @nestjs Wenn der Endpunkt `/degrees` per GET-Request aufgerufen wird, wird also das Ergebnis der findAll-Methode zurückgegeben. Wenn der Endpunkt `/degrees/5` aufgerufen wird, wird das Ergebnis der findOne-Methode zurückgegeben. Die findOne-Methode erhält außerdem weitere Parameter, die auch in vielen anderen Methoden im Backend ähnlich genutzt werden. Der erste Parameter enthält die Id aus dem Pfad der Anfrage (im Beispiel /degrees/5, wäre das die 5). Der zweite Parameter enthält ein Request-Objekt. Dieses wird genutzt, um die in dem Request übergebenen Header auszulesen. Im aktuellen Beispiel wird die angefragte Sprache ausgelesen, um vom DegreeService Informationen in der Sprache des Benutzers zu erhalten.

Über den Constructor werden per Dependency Injection @DependencyInjectionAngular die benötigten Services übergeben. Das Framework nest.js sorgt dafür, dass die Services einmalig instanziiert werden. 

#codeFigure("degree.controller.ts (Auszug)", <degreeController>, "degree.controller")

#heading("Datenverändernde Endpunkte", level: 4, numbering: none, outlined: false)
Die Endpunkte die Daten erstellen, oder bearbeiten sind verglichen mit den bisher vorgestellten Endpunkten weitaus komplexer, sodass es mehrere Design-Entscheidungen zu treffen gibt. 

Das aufrufende System (hier das Frontend) sendet Daten im JSON-Format an das Backend.
Ein naiver Ansatz zur Erstellung einer Methode für das Erstellen und Bearbeiten eines Modules ist es, das erhaltene JSON direkt an den Prisma-Client zu übergeben und zu hoffen, dass der Prisma-Client das JSON korrekt verarbeitet.
Leider gibt es bei diesem Ansatz gleich mehrere Hindernisse.

Wenn das JSON nur aus einfachen Datentypen wie Zeichenketten, Zahlen und Booleans bestehen würde, wäre der naive Ansatz ausreichend. Da das Modul-JSON jedoch auch Objekte und Arrays enthält, müssen diese zunächst herausgefiltert werden. Dies kann mithilfe von "destructuring assignment" @DestructuringAssignmentJavaScript2023 erledigt werden (siehe @extractComplexFields). Hierbei werden die Eigenschaften mit komplexeren Datentypen aus dem JSON (moduleDto) extrahiert und für die spätere Verwendung in eigene Variablen gespeichert. Die verbleibenden Eigenschaften befinden sich anschließend im Objekt "moduleData" (@moduleData).
Dieses Objekt kann dann tatsächlich direkt an den Prisma-Client übergeben werden, um die darin enthaltenen Werte in die Datenbank zu schreiben (@moduleData2).
Die zuvor extrahierten Daten können nun seperat behandelt werden.

In @connectResponsible ist zu sehen, wie die Eigenschaft der Verantwortlichen Person (@responsible) gesetzt wird. Da beim Erstellen eines Modules eine verantwortliche Person aus einem Dropdown ausgewählt wird, muss im Backend kein neuer Eintrag für die Person angelegt werden. Stattdessen muss der Eintrag des Moduls nur eine Referenz auf die ausgewählte, bereits in der Datenbank bestehende Person erhalten. Dies ist wie im Beispiel gezeigt mit der Funktion connect @RelationQueriesConcepts möglich. Auf die gleiche Art kann auch bei der Bearbeitung eines Moduls eine andere Person gesetzt werden. Die Funktion connect ändert im Hintergrund einfach die Eigenschaft responsibleId in der Modultabelle.

Auch für n-m-Beziehungen wird die connect-Funktion von Prisma genutzt. 
Ein Modul hat Voraussetzungen (Requirements). Eine Voraussetzung könnte es sein, dass die Module BIN-100 und BIN-101 abgeschlossen sein müssen. Ein Modul hat also eine Requirement und eine Requirement hat 0 bis n viele Module. Übergibt man die gewünschten Modul-Ids mit der Funktion connect (wie in Zeile 34 zu sehen), erstellt Prisma die benötigten Einträge in einer Zwischentabelle, um die Beziehung abzubilden. Allerdings werden dabei die bereits vorhandenen Einträge nicht automatisch gelöscht. Das Löschen der bereits vorhandenen Einträge muss manuell angefordert werden. Dies ist beispielsweise möglich, indem der set-Methode ein leeres Array übergeben wird. (siehe @clearModules). Alternativ kann auch direkt die set-Methode genutzt werden, um die neuen Module zu setzen (siehe @clearModules2). Das direkte setzen der neuen Werte mithilfe der set-Methode ist die bevorzugte Variante, da hier mit weniger Anweisungen das selbe Ergebnis erreicht wird. Der Code wird hierdurch lesbarer, deshalb sollte diese Variante verwendet werden.

Prisma bietet weiterhin eine Methode upsert an, die die Update-Methode und die Create-Methode kombiniert. Hierzu werden zunächst die Update und Create JSONs in eigene Variablen geschrieben. Anschließend können diese an die Upsert-Methode übergeben werden (siehe @upsert). Außerdem wird eine Filter-Abfrage benötigt, mit der Prisma ermitteln kann, ob ein Update, oder ein Create nötig ist (@upsertFilter). 

Abschließend muss außerdem evaluiert werden, ob der entstandene Code verständlich und kompakt genug ist. Das vorgestellte Beispiel ist durch die vielen komplexen Datentypen stark gewachsen. Um den Code also wartbarer, lesbarer und verständlicher zu machen, wurde zuletzt noch die Codequalität optimiert. Hierzu wurden statt einer gemeinsamen Upsert-Methode zwei unterschiedliche Methoden (Create und Update) erstellt. Hierdurch wurde die Zuständigkeit klarer definiert. Außerdem wurden die verschiedenen Zuweisungen der komplexen Datentypen in jeweils eigene Methoden extrahiert. Dies hatte neben des nun weitaus besser lesbaren Codes den zusätzlichen Vorteil, dass die Methoden an verschiedenen Stellen verwendet werden konnten, sodass redundanter Code verringert wurde. Jedoch ergab sich daraus auch ein Nachteil. Durch das sequenzielle Verändern der Daten, konnte es passieren, dass die ersten Veränderungen erfolgreich sind, und dann beispielsweise beim Zuweisen der zuständigen Person ein Fehler auftritt. In dem Fall wäre das Update dann nur teilweise erfolgreich. In der frühereren Version als alle Updates in einer Abfrage stattfanden, wäre in so einem Fall das gesamte Update fehlgeschlagen. Ein nun mögliches Teilupdate kann zu unerwarteten Fehlern führen und ist für den Benutzer entweder nur schwer zu erkennen oder unverständlich. Um dieses Verhalten wiederherzustellen wurden letztlich alle Anweisungen in einer Transaktion @TransactionsBatchQueries zusammengefasst. Hierdurch konnte der Vorteil der besseren Codequalität bestehen bleiben und dennoch das gewünschte Verhalten erzielt werden. Im Falle eines Fehlers macht Prisma nun automatisch die bisher vorgenommenen Änderungen rückgängig, sodass keine inkonsistenten Daten entstehen können. Der neue Code ist deutlich lesbarer (siehe @endpointAfter).


#heading("Changelog", level: 4, numbering: none, outlined: false)<implementChangelog>
Für die Anzeige der Änderungen (@SHOWCHANGES) müssen die Änderungen zunächst im Backend ermittelt werden. 

Im gezeigten Codebeispiel werden zunächst alle verfügbaren Felder eines Modules ermittelt. Hierzu wird die Methode Object.keys @ObjectKeysJavaScript2023 verwendet, welche ein Array aller Felder des Modules zurückgibt. Die erhaltenen Felder werden im Anschluss in die Kategorien "Arrays", "Übersetzungen" und "Primitive Felder" aufgeteilt (@compareFields).
#codeFigure("compareFields", <compareFields>, "compareFields")

Damit die ermittelten Felder jetzt verglichen werden können sind verschiedene Vergleiche nötig, die im folgenden kurz erklärt werden. Die Implementierungen der Compare-Methoden sind im Anhang (@compareFields2) zu finden. 

Wenn das Feld einen primitiven Datentypen hat, ist der Vergleich sehr einfach – es kann dann einfach der Feldinhalt miteinander verglichen werden (@comparePrimitiveField). Wenn es sich bei dem Feld jedoch um ein Array handelt, wird der Vergleich etwas komplizierter. In dem Fall interessiert es uns, ob es neue Einträge gibt, oder ob Einträge entfernt wurden. Hierzu müssen dann die Ids verglichen werden (@compareArrayField). Für das Array translations, in dem die übersetzten Texte abgelegt werden, gibt es eine weitere Ausnahme. Hierbei müssen die Inhalte der Objekte im Array miteinander verglichen werden, die zu derselben Sprache gehören. Hierzu wird das entsprechende zu vergleichende Objekt mithilfe der filter-Methode @ArrayPrototypeFilter2023 herausgesucht (@compareTranslations) und die darin enthaltenen Eigenschaften verglichen.







#heading("Öffentliche Endpunkte", level: 4, numbering: none, outlined: false)

Des Weiteren ist es wichtig, zwischen öffentlichen und privaten Endpunkten zu unterscheiden. Damit User im Frontend auch ohne Anmeldung die Module ansehen können, müssen manche Endpunkte ohne Authentifizierung erreichbar sein. Hierzu wurde ein eigener Dekorator (@publicDecorator) erstellt. Dieser kann einfach über einen Endpunkt geschrieben werden, um diesen als öffentlich zu markieren (@moduleController). Damit dies funktioniert, musste zusätzlich der AuthGuard durch eine eigene Implementierung (@authGuard) ersetzt werden. Diese neue Implementierung überprüft, ob in den Metadaten "isPublic" steht. Wenn dies der Fall ist, kann die Anfrage mit `return true` genehmigt werden. Falls diese Metadaten nicht gesetzt sind, wird die ursprüngliche Implementierung von canActivate (@authGuard, Zeile 14) aufgerufen, um zu überprüfen, ob ein gültiger Token mitgesendet wurde. 


#codeFigure("public.decorator.ts", <publicDecorator>, "publicDecorator")

#codeFigure("module.controller.ts", <moduleController>, "getModule")

#codeFigure("jwt-auth.guard.ts", <authGuard>, "authGuard")


#heading("Informationen über den aufrufenden User", level: 4, numbering: none, outlined: false)

Manche Endpunkte benötigen genauere Informationen über den aufrufenden User, also den User, der im Frontend angemeldet ist. Das Bearbeiten von Modulen soll beispielsweise nur Usern erlaubt sein, die entweder verantwortlich für den gesamten Studiengang sind, oder verantwortlich für das bearbeitete Modul. Da sich die User mithilfe eines Jwt-Tokens authentifizieren, kann dieser hierzu einfach genutzt werden. In der jeweiligen Controller-Methode muss dann als Parameter lediglich `@User() user:UserDto` hinzugefügt werden, um dann mithilfe von user.role die Rolle des Users zu erfahren oder mit user.id die Id des Users.

Die Information über den User wird vom Framework nestjs beim Aufruf der Methode `canActivate` herausgefunden und wird dann automatisch als Parameter übergeben. In @authGuard ist jedoch zu sehen, dass der \@Public-Decorator aufgrund des frühen returns diese Anweisung überspringt. Für Methoden, die also für nicht angemeldete Benutzer zur Verfügung stehen sollen und die für angemeldete User anders funktionieren funktioniert der \@User-Parameter also nicht ohne weiteren Aufwand. Ein Beispiel hierfür ist die Auflistung aller Studiengänge. Diese sollen auch unangemeldeten Besuchern angezeigt werden, jedoch sollen angemeldete studiengangsverantwortliche Personen auch versteckte Studiengänge angezeigt bekommen. 

Damit der User auch bei öffentlichen Endpunkten verfügbar ist, gibt es zwei Möglichkeiten.
Als erste Möglichkeit könnte ein weiterer Guard erstellt werden (siehe @injectUser). @nestjs Dieser Guard kann mithilfe des \Use-Guards-Decorator aktiviert werden (@injectUserCall).

#codeFigure("InjectUser-Implementierung", <injectUser>, "injectUser")

#codeFigure("findOne() in department.controller.ts", <injectUserCall>, "injectUserAufruf")


Eine zweite Möglichkeit wäre, den Aufruf von canActivate vorzuziehen. Wenn dieser direkt als erstes durchgeführt wird, wird in jedem Fall der User injectet und öffentliche Endpunkte sind trotzdem möglich. Diese Möglichkeit hat den Vorteil, dass nicht daran gedacht werden muss, wie in @injectUserCall den InjectUser-Guard an die verschiedenen Methoden zu setzen. Aus diesem Grund wird diese Möglichkeit favorisiert.

Da canActivate eine Exception wirft, falls der User nicht eingeloggt ist, muss diese angefangen werden, damit trotzdem geprüft werden kann, ob es den \@Public-Decorator gibt. Außerdem kann canActivate ein Observable zurückgeben. Da wir jedoch einen Boolean-Wert benötigen, können wir die Methode lastValueFrom() aus der rxjs-Bibliothek (@RxJSLastValueFrom) nutzen, um einen konkreten Wert zu erhalten.

#codeFigure("canActivate() - Verbessert", <canActivateNew>, "canActivateNew")

// https://docs.nestjs.com/recipes/passport#request-scoped-strategies





=== PDFs generieren <pythonScript>

Das Generieren einer Modulbeschreibung in Form einer PDF-Datei verläuft in mehreren Teilschritten:

1. Die Studiengangsverantwortliche Person (User) fragt neue PDF Version an
2. Das Backend erstellt aus den vorliegenden Informationen eine .tex-Datei und veröffentlicht einen Auftrag zur Kompilierung
3. Ein Kompilierungs-Server nimmt den Auftrag an und ruft die .tex-Datei aus dem Backend ab 
4. Der Kompilierungs-Server kompiliert die .tex-Datei zu einer PDF-Datei und gibt diese ans Backend zurück
5. Das Backend meldet das Ergebnis an den User zurück
6. Der User prüft das Ergebnis und gibt es frei
7. Die neue PDF Version steht bereit

In den Schritten 2 bis 5 werden eine .tex-Datei und eine .pdf-Datei generiert. Dies wird im Folgenden näher beschrieben.

#heading("Generierung der .tex-Datei", level: 4, numbering: none, outlined: false)


Die Grundlage für die Generierung der .tex-Datei bildet ein Python-Skript, welches von #heine bereitgestellt wurde. Dieses Script wurde im Rahmen dieser Arbeit an die veränderte Datenstruktur angepasst. Anschließend wurde das Skript in TypeScript umgewandelt und in das neue Backend eingebaut. Hierzu wurde das Datenbankschema um die benötigten Einträge erweitert und es wurde ein neuer Controller mit dazugehörigem Service eingesetzt, welcher die Endpunkte und Methoden zur Generierung der .tex-Datei anbietet. 

Das ursprüngliche Python-Skript enthielt eine statische Auflistung der Felder in der Tabelle des Modulhandbuches. Darin enthalten war der gewünschte Text (z.B. Moduldauer) und das dazugehörige Feld (module.courseLength). Diese statische Auflistung wurde im Rahmen der Umstellung in die Datenbank verschoben. Hierdurch soll der Wartungsaufwand reduziert werden. Mehrere Auslöser können dazu führen, dass sich die Struktur des zu generierenden Pdfs ändert. Es könnte neben Englisch und Deutsch eine zusätzliche Sprache angeboten werden. Auch ist es denkbar, dass zusätzliche Felder eingeführt werden. Für die Studiengänge an der Fakultät 3 wird beispielsweise die Information "Gewichtung" auf den Modulhandbüchern abgedruckt. Um nun verschiedene Pdf-Strukturen für verschiedene Studiengänge anzubieten, ist nun nur noch eine Veränderung der Datensätze in der Datenbank notwendig. Hierfür könnte eine zusätzliche Oberfäche erstellt werden, mit der die User selbst die Pdf-Struktur konfigurieren können.

In @appendStructureItems ist zu sehen, wie der LateX-Code für ein SubModul generiert wird. Ein reduziertes Beispiel für ein StructureItem ist in @structureItem zu sehen. Mit der Eigenschaft takeTwoColumns (@structureItemTakeTwoColumns) können gewünschte Eigenschaften in @appendStructureItemsTakeTwoColumns breiter dargestellt werden. Dies passiert im Modulhandbuch der Abteilung Informatik beispielsweise für das Feld @erg, da dort in der Regel viel Text enthalten ist. In @structureItemSuffix ist zu sehen, wie an die gespeicherte Information ein Suffix angehangen werden kann. Dies ist beispielsweise wie im gezeigten Beispiel für Zeitdauern interessant, wird aber auch für die Anzeige der Dauer (z. B. 1 Semester) genutzt. In @structureItemName ist abschließend die Übersetzung für die Zeilenüberschrift angegeben.

#codeFigure("appendStructureItems()", <appendStructureItems>, "appendStructureItems")

Damit zu den Zeilenüberschriften auch die dazugehörigen Werte gedruckt werden können, wird die Methode getValue genutzt (@getValueCall). Hierzu wird die Eigenschaft path genutzt, die jedes Field besitzt (@structureItemPath). Im genannten Beispiel ist die Ermittlung noch einfach - hoursPresence ist ein Feld im Submodul und kann daher einfach ausgelesen werden. Es gibt jedoch auch komplexere Fälle die betrachtet werden müssen. Es gibt zum Beispiel den Pfad responsible.firstName, bei dem es schon etwas komplizierter wird. Im Falle der translations wird außerdem ein Zugriff auf ein Array benötigt (z.B. requirementsSoft.translations[0].name). Als letzte Art gibt es die Methodenaufrufe. Für das Feld @submodules wird beispielsweise eine Auflistung der Submodule benötigt. Diese ist etwas komplexer zu ermitteln und wird daher in einer eigenen Methode erledigt. Im Feld path steht in diesem Fall dann einfach der Name der aufzurufenden Methode "submodules()". Manche dieser Methoden könnten asynchron sein, weshalb hier auch noch einmal unterschieden werden muss (siehe @getValueFromPath). Die Methoden haben alle die selbe Signatur, damit sie auf die gleiche Art aufgerufen werden können. 

Der Wert für das komplexeste Beispiel "requirementsSoft.translations[0].name" wird wie folgt ermittelt:
1. Die Informationen des Teilmodules in eine Variable (submodule) laden
2. Den Pfad bei jedem Punkt trennen
3. Für den ersten Teil des Pfades (requirementsSoft) den Wert aus der Variable submodule auslesen
4. Aus diesem neuen Objekt wird der zweite Teil des Pfades ausgelesen (translations[0])
5. Zum Schluss wird aus dem neuen Objekt dann noch die Eigenschaft "name" ausgelesen
6. Alle Segmente des Pfades wurden abgelaufen, sodass das Ergebnis des letzten Schrittes zurückgegeben werden kann


Die Methode getNestedProperty (@getNestedProperty) sorgt für den soeben beschriebenen Ablauf. Da diese Methode recht kompliziert ist, wurden hier einige Kommentare ergänzt, die Entwickelnden helfen sollen, die Logik zu verstehen. Mit der reduce-Methode (@reduce) werden die einzelnen Segmente des Pfades abgelaufen.@ArrayPrototypeReduce2023 Die RegEx (@detectArray) erkennt ob das Segment ein Array ist und gibt das Segment, den Namen des Arrays sowie die angegebene Zahl zurück. Da das Segment nicht nochmal benötigt wird, wird es mithilfe des Unterstriches in @ignoreVar verworfen. @DestructuringAssignmentJavaScript2023




#heading("Generierung der .pdf-Datei", level: 4, numbering: none, outlined: false)
Für die erfolgreiche Kompilierung der .tex-Datei muss die Server-Umgebung konfiguriert werden. Zusätzlich zur Möglichkeit, Latex kompilieren zu können, müssen die von der .tex-Datei benötigten Pakete bereitstehen. Um diesen Aufwand zu verringern wird ein Docker-Image eingesetzt, welches es ermöglicht, ohne weiteren Konfigurationsaufwand per HTTP-Request eine .tex-Datei zu kompilieren @YtoTechLatexonhttp2024.

Außerdem wurde ein neues python-Skript erstellt, welches einen Kompilierungs-Server implementiert. Das Skript prüft in regelmäßigen Abständen, ob in der API ein Auftrag zur Erstellung einer neuen PDF-Datei vorliegt. Wird bei der Prüfung ein Auftrag gefunden, markiert der Server diesen als "laufend", damit dies auch im Frontend ersichtlich ist und damit kein anderer Server den Auftrag übernimmt. Anschließend ruft der Server die .tex-Datei aus dem Backend ab und übergibt sie an den Docker-Container. Der Docker-Container erstellt nun die PDF-Datei und gibt diese an den Server zurück. Der Server übermittelt das Ergebnis zurück an das Backend. @NestJSStreamingFiles Die Erstellung des PDFs ist entkoppelt vom Backend. Somit können beispielsweise mehrere Server betrieben werden, um die PDF-Erstellung zu parallelisieren. Auch können die Server unterschiedlich implementiert werden, sodass auch andere Dateiformate umsetzbar wären. Zukünftige Implementierungen könnten beispielsweise Word-Dokumente in ein PDF-Dokument umwandeln, oder LateX-Alternativen wie zum Beispiel Typst @TypstComposePapers in ein PDF-Dokument kompilieren. Beim Hinzufügen weiterer Kompilierungs-Server muss das Backend nicht angepasst werden, da dieses lediglich die Aufträge anbietet und die Aufträge nicht selbst an konkrete Server zuweist.



== Frontend <createFrontend>

Im Gegensatz zum Backend ist das Frontend eine neue Anwendung, zu der es keinen Bestandscode gab. Für das Frontend wurde ein neues Angularprojekt erstellt und mithilfe des Paketmanagers npm die benötigten Pakete hinzugefügt, von denen in den folgenden Unterabschnitten noch einige vorgestellt werden.

Die generelle Struktur des Frontends wurde wie folgt konzipiert. Der User befindet sich beispielsweise in der Übersicht aller Module. Hier kann ein Modul angeklickt werden, um die Detailansicht aufzurufen. Wenn der User angemeldet ist und entsprechende Rechte besitzt, kann dann noch der Bearbeiten-Button gedrückt werden, um in die Bearbeitungsansicht zu wechseln. Es gibt also immer eine Auflistung, gefolgt von einer Detailansicht und gegebenenfalls einer Bearbeitungsansicht.

Der Code der Anwendung besteht aus Komponenten und Services. Die Komponenten werden in der Anwendung dargestellt und werden modular genutzt. Die Services können von allen Komponenten genutzt werden und bieten Methoden zum Laden von Daten aus dem Backend an. Damit die Services wissen, unter welcher URL das Backend erreichbar ist, ist diese URL in einer Datei `environment.ts` gespeichert und kann von da abgerufen werden. Dies ermöglicht den schnellen Austausch dieser URL. Für den produktiven Einsatz gibt es zudem eine `environment.prod.ts`, die die URL des produktiven Backends enthält. Sobald das Frontend mit dem Befehl `ng build --configuration=production` in der Produktiv-Version kompiliert wird, sorgt ein Eintrag in der `angular.json` (@angularJson) dafür, dass die Environment-Datei entsprechend ausgetauscht wird.


Die Entscheidung, welche Komponente in der Anwendung gezeigt wird, wird vom RouterModule übernommen. In der main.component.ts der Anwendung (@mainComponent) wird lediglich die Topbar (welche auf jeder Seite gezeigt werden soll) und das Router-Outlet platziert. 

Das Router-Outlet wird dann in Abhängigkeit der besuchten URL anhand eines Eintrages aus der app.routes.ts (@appRoutes) mit der dort gesetzten Komponente ausgetauscht.

#codeFigure("angular.json (Auszug)", <angularJson>, "angular.json")

#codeFigure("main.component.html", <mainComponent>, "main.component")

#codeFigure("app.routes.ts (Auszug)", <appRoutes>, "app.routes")

Das Wechseln auf eine andere Seite ist nun sehr einfach mithilfe eines Methodenaufrufes möglich. Um Beispielsweise auf die Seite /faculty/4/department/2/course/1/module/1 zu wechseln, wird dieser Aufruf benötigt: `await this.router.navigate(['faculty', module.facultyId, 'department', module.departmentId, 'course', module.courseId, 'module', module.id]);` 

Verkürzen lässt sich dies dann noch, falls ein Teil der URL bereits korrekt ist. Befinden wir uns zum Beispiel bereits auf der Seite /faculty/4/department/2/course/1 und wollen nur noch /module/1 anhängen, so können wir das Argument "relativeTo" nutzen und müssen dann nicht mehr alle Segmente anhängen: `await this.router.navigate(['module', module.id], {relativeTo: this.route});`.

    
  


=== PrimeNG
Ein UI-Framework kann bei der Implementierung des Frontends unterstützen. Vom Framework angebotene vorgefertigte Komponenten müssen nicht selbst implementiert werden. Nach dem Dont-Repeat-Yourself-Prinzip wird dadurch der Entwicklungsaufwand reduziert und die Codequalität verbessert. @clean_code_2012_robert_martin Allerdings muss die Nutzung eines Frameworks sorgfältig abgewogen werden. Jede Einführung zusätzlicher Abhängkeiten birgt gewisse Risiken. Das Framework könnte eine Sicherheitslücke beeinhalten @NpmThreatsMitigations oder könnte zu anderen (zukünftigen) Abhängigkeiten inkompatibel sein. Diese Riskiken können durch eine vorherige Untersuchung der Frameworks verringert werden. Wenn ein Framework open source ist und eine große Anzahl an Unterstützern hat, ist es theoretisch möglich, dass Sicherheitslücken zügig gefunden und behoben werden @OpenSourceSicherheitVerstaendlichErklaert. Da dieses Projekt keine geheimen oder personenbezogenen Daten verarbeitet, wird das geringe Risiko das mit der Verwendung eines Frameworks einhergeht eingegangen - zu Gunsten einer angenehmeren Entwicklung und eines schöneren Ergebnisses.

Um das zu benutztende Framework zu identifizieren wurden zunächst zwei bekannte Frameworks `@ng-bootstrap/ng-bootstrap` @AngularPoweredBootstrap und `primeng` @PrimeNGAngularUI miteinander verglichen. Beide Frameworks haben hohe Downloadzahlen und eine gute Dokumentation, was ein Indikator dafür sein könnte, dass sie in diesem Projekt hilfreich sein könnten. Da PrimeNG weitaus mehr Komponenten anbietet, wird in diesem Projekt PrimeNG verwendet. Dank der Nutzung von PrimeNG sollte die Implementierung der verschiedenen Tabellen und Formularen weitaus effizienter sein. Außerdem sieht das System insgesamt einheitlich und modern aus, weil alle PrimeNG-Komponenten dem gleichen Theme folgen. @PrimeNGAngularUI     



=== Styling
Um die Darstellung der Inhalte von der Struktur der Inhalte zu trennen, werden in der Webentwicklung die Regeln zur Darstellung üblicherweise in CSS-Dateien definiert und dann in die HTML-Dateien eingebunden @css. Für dieses System wurde SASS @sass, eine Erweiterung von CSS verwendet, die zusätzlich Features einführt. Durch die Nutzung von Einrückungen kann der Code so etwas lesbarer gestaltet werden, da lange Selektoren übersichtlicher dargestellt werden können und nicht wiederholt werden müssen. @sassStyleRules

Es wurde eine globale SASS-Datei erstellt, um Klassen die an vielen Stellen verwendet werden sollen zu definieren (siehe @sassMain). Es gibt in der Anwendung viele klickbare Elemente. Um darzustellen, dass diese klickbar sind, soll sich der Cursor verändern, wenn er sich über dem Element befindet. Hierzu muss nun einfach die Klasse .clickable auf das Element gelegt werden. Neben .clickable gibt es noch zahlreiche weitere Klassen wie zum Beispiel ("fullWidth", "smallPadding", "mediumPadding" und "largePadding"), die für eine konsistente Darstellung in der Anwendung sorgen. Außerdem wurde overwritePrimeNg.sass erstellt, welche ausgewählte Eigenschaften von PrimeNG überschreibt. SASS erlaubt die Nutzung von Import-Statements, sodass die zusätzliche Datei einfach in der globalen SASS-Datei mit der Anweisung `@import "overwritePrimeNg"` importiert werden kann. 

#codeFigure("Auszug styles.sass", <sassMain>, "sassMain")

Des Weiteren hat jede Komponente nochmal eine eigene .sass-Datei, in der Komponentenbezogene Darstellungseigenschaften gesetzt werden können. Diese .sass-Dateien werden nur auf die Elemente in der Komponente angewendet, sodass alle anderen Komponenten unverändert bleiben. @ViewEncapsulation 

=== Responsive Design<responsiveImplemented>
In verschiedenen Gesprächen mit zukünftigen Nutzern stellte sich heraus, dass die administrativen Oberflächen auf Desktop-PCs bedient werden. Für die administrativen Oberflächen muss die Ansicht auf mobilen Geräten also nicht optimiert werden. Die Übersicht der Studiengänge, die Übersicht der angebotenen Module sowie die moderne Ansicht der Moduldetails könnte jedoch von Studierenden auf mobilen Geräten geöffnet werden und sollte daher für die mobile Ansicht optimiert werden @RESPONSIVE.

Damit die Anzeige der Studiengänge (@menu) auf mobilen Geräten gut aussieht musste nicht viel angepasst werden. Statt die Karten der Studiengänge nebeneinander aufzureihen werden diese in der mobilen Ansicht nun untereinander platziert. Für die Desktopansicht wird hier ein Grid @cssGrid mit drei Spalten genutzt genutzt. Damit es in der mobilen Ansicht nur eine Spalte gibt, kann der Wert `grid-template-columns` mithilfe von `unset` @cssUnset zurück auf den ursprünglichen Wert gesetzt werden (siehe @cssUnsetCode). Für die Erkennung, ob die mobile Ansicht benötigt wird, wird eine Media Query genutzt. Diese sorgt dafür, dass die genannte Spalteneingenschaft nur für Geräte mit einer Bildschirmbreite unter 850 Pixeln zurückgesetzt wird. @ertel_responsive_nodate

#codeFigure("courses.component.sass", <cssUnsetCode>, "cssUnset")


Die Anzeige aller Module ist in der Desktopansicht eine Tabelle. Diese wird auf mobilen Endgeräten zwar dargestellt, jedoch muss von links nach rechts gescrollt werden, um alle Felder sehen zu können. Um diese Ansicht zu optimieren, kann eine Funktion von PrimeNG genutzt werden, um für mobile Geräte aus der Tabelle eine Auflistung von Karten zu machen. Das Setzen von `responsiveLayout="stack"` reicht hier aus. Um die Felder auf den mobilen Karten noch zu beschriften muss für jedes Feld eine Beschriftung hinzugefügt werden. Die Klasse `p-column-title` muss dabei auf die entsprechende Beschriftung gesetzt werden, damit PrimeNg sie passend ein und ausblendet. @primengTable 


//#imageFigure(<responsiveModules>, "responsiveModules.png", "Mobile Auflistung der Module", width:60%)

//#imageFigure(<responsiveModuleDetails>, "../Images/responsiveModuleDetails.png", "Mobile Anzeige der Moduldetails", width:60%)

Zuletzt muss noch die Anzeige der Moduldetails optimiert werden. Diese ist etwas komplexer aufgebaut, da sie aus vielen verschiedenen Komponenten besteht. Die Komponenten in der ersten Reihe in @moduleDetailResult sind beispielsweise Info-Card-Components und bestehen aus einem Icon, einem Label und einem Anzeigewert. Neben den Info-Cards gibt es noch Stat-Cards für die Anzeige des Kuchen-Diagrammes (siehe @moduleDetailResult), Text-Cards für die Anzeige von einfachen Texten (z.B. Vorraussetzungen) und Split-Text-Cards für die Anzeige von zwei verschiedenen Texten innerhalb einer Karte. Für die Optimierung bei kleinen Bildschirmgrößen können Info-Card und Text-Card ignoriert werden, da diese bereits vollständig anzeigbar sind. Die Split-Text-Card muss auf kleinen Bildschirmgrößen die Texte untereinander statt nebeneinander zeigen. Hierzu musste die Flex-Direction mithilfe einer Media Query auf "column" gesetzt werden. @noauthor_flex-direction_2024 Dies war auch bei der Stats-Card erforderlich. Hier wurden zusätzlich die Texte anders ausgerichtet, damit sie auf der Karte zentriert angezeigt werden.

Die einzelnen Karten sind in der Ansicht der Moduldetails in einem Grid angeordnet. Dieses hat in der Desktopansicht 5 Spalten. Die Info-Karten passen in eine Spalte, während sich Karten mit mehr Inhalt auf mehrere Spalten verteilen dürfen. Damit auf der mobilen Ansicht die Karten vollständig angezeigt werden können, ohne dass ein horizontales Scrollen notwendig ist, wird die Eigenschaft `grid-column` von jeder Karte auf 5 gesetzt, sodass es pro Zeile jeweils eine Karte gibt. @cssGrid



=== Übersetzbarkeit <uebersetzbarkeit>

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


=== Erstellen eines neuen Pdfs<createPdfUI>
Das Erstellen eines neuen Pdfs kann in der Studiengangsübersicht gestartet werden. Hierbei öffnet sich ein Popup, welches anzeigt, wann für den Studiengang zuletzt ein Pdf veröffentlicht wurde. In Zukunft könnten hier auch die Veränderungen seit der letzten Veröffentlichung aus dem Changelog angezeigt werden. Im Popup kann ausgewählt werden, für welche Sprachen das Pdf generiert werden soll @createPdfStep1. Während der Generierung wird dem User der Status angezeigt und sekündlich aktualisiert (@createPdfStep2). Der User kann nun entweder auf das Ergebnis warten, oder die Maske schließen und in einer seperaten Maske die vergangenen Kompilierungsaufträge ansehen.

Sobald das Pdf vorliegt, kann der User dieses ansehen und dann entweder verwerfen oder freigeben. Mit der Freigabe steht es dann auch für nicht angemeldete User bereit.

#imageFigure(<createPdfStep1>, "createPdf.png",  "Pdf veröffentlichen - Schritt 1", width: 90%)

#imageFigure(<createPdfStep2>, "CreatePdfStep2.png", "Pdf veröffentlichen - Schritt 2")



=== Subscriptions, Intervalle und Memory Leaks
In @createPdfUI wurde beschrieben, wie der Status des Auftrages sekündlich aktualisiert wird. Hierzu wird ein Intervall genutzt, welches sekündlich eine Anfrage an das Backend sendet. Damit dieses Polling stoppt, sobald die Maske geschlossen wird, muss es gestoppt werden. 

Außerdem werden beim Wechseln der Anzeigesprache die angezeigten Daten in jeder Maske neu geladen. Hierzu wird beim Öffnen der Maske wie in @uebersetzbarkeit beschrieben ein BehaviourObject genutzt. Auch dieses sollte beim Schließen der Maske deabboniert werden. Andernfalls gibt es die Gefahr von Memoryleaks - solange Events abboniert sind, kann die Maske nicht aus dem Arbeitsspeicher entladen werden. @AngularComponentLifecycle

Aus diesen beiden Gründen, muss in einigen Masken das Interface OnDestroy @AngularComponentLifecycle implementiert werden. Dieses wird beim Schließen des Components aufgerufen. Der darin enthaltene Code (@onDestroy) ist dann recht simpel - das Intervall wird gestoppt und die Subcription auf das languageSubject wird deabboniert. 

#codeFigure("onDestroy Implementierung", <onDestroy>, "onDestroy")

=== Suchfunktion<implementSearch>

Die Suchfunktion soll während der Eingabe geeignete Module vorschlagen (@SEARCH). Zur besseren Übersicht sollen diese nach Studiengang gruppiert werden. Hierzu müssen die aus dem Backend erhaltenen Daten auf das benötigte Format umgewandelt werden.
Mit der `.map`-Funktion lässt sich in JavaScript der Aufbau eines Arrays verändern. @MapJavaScriptMDN In @searchCode ist zu sehen, wie das neue Array zusammengebaut wird. Als Erstes werden die Studiengänge hinzugefügt. Für jeden Studiengang werden die darin enthaltenen Module hinzugefügt. Hierbei ist zu beachten, dass als `value` ein Link gesetzt werden muss, welcher beim Anklicken des Eintrages geöffnet werden soll. 

#codeFigure("Daten für die Suche ermitteln", <searchCode>, "searchGroup")

=== URL-basierte Erkennung von Seitenelementen
Wenn ein User ein Modul öffnet, ändert sich die URL. Für das Modul mit der Id 1 könnte der Pfad dann beispielsweise so aussehen: /faculty/4/department/2/course/1/module/1. Dies hat den Vorteil, dass der User den Link mit anderen Usern teilen kann. Außerdem funktionieren dadruch die Navigationstasten im Browser und der Browserverlauf zeigt hilfreiche Informationen.

Für die Implementierung von verschiedenen Funktionen ergibt sich außerdem ein weiterer Vorteil. Durch die Angabe verschiedener Informationen in der URL können diese auch im Code verwendet werden. Mithilfe der Informationen aus der URL wird zum Beispiel der Breadcrumb in der oberen Leiste (@grundgerüst) befüllt (@PATH). Damit diese Funktionalität gekapselt ist und sich nicht wiederholt, wurde hierfür eine eigene Methode entworfen (@urlSegment). Mithilfe des Aufrufes von getIdFromSegment("faculty") kann dann beispielsweise herausgefunden werden, durch welche Faktultät der User gerade navigiert. Hierzu teilt die Methode getIdFromSegment() die aktuelle URL in Segmente auf, und gibt die Zahl nach dem gewünschten Segment zurück. Wenn der Pfad /faculty/4/department/2 wäre, würde getIdFromSegment("faculty") den Wert 4 zurückgeben.

#codeFigure("url-segment.service.ts", <urlSegment>, "urlSegmentService")


=== Anlegen und Bearbeiten von Modulen
Die Masken zur Bearbeitung der Module und Teilmodule sind eine zentrale Stelle der Anwendung. Um hier eine gute Benutzbarkeit zu gewährleisten, sind mehrere Konzepte genutzt worden. 

#heading("Übersetzbarkeit", level: 4, numbering: none, outlined: false)<translatability>


Für die Anforderung der Übersetzbarkeit wurde in @addModule, @translateDropdown und @translatePopup eine Möglichkeit konzipiert, Texte in verschiedenen Sprachen zu hinterlegen. Nach erneuter Betrachtung des Problemes, ergab sich eine einfachere Lösung. Ein Nachteil der urspünglichen Lösung war, dass es für jedes Eingabefeld ein Popup gab. Dies erhöhte den Aufwand der Eingabe drastisch, da für jede Eingabe ein neues Fenster geöffnet wurde und auch wieder geschlossen werden musste. Um die Anzahl der Popups zu verringern, wurden stattdessen gewöhnliche Textfelder genutzt. Um dennoch verschiedene Sprachen zu unterstützen, wird die Eingabemaske nun für jede Sprache einmal wiederholt. Eine Anzeige im oberen Bereich zeigt die einzelnen Schritte des Bearbeitungsprozesses (@editModule). 

In @components sind die einzelnen Komponenten einer Bearbeitungsmaske (z.B. die Modulbearbeitung) zu sehen. Wenn auf "Bearbeiten" gedrückt wird, lädt der Router das Edit-Component (z.B. module-edit.component.ts). Das Edit-Component erhält das zu bearbeitende Modul mit allen Eingenschaften über einen \@Input-Parameter (siehe @twoWay). Dieses Objekt wird an die folgenden Komponenten weitergegeben. Hierzu wird das Two-Way-Binding von Angular verwendet, damit das Objekt in beide Richtungen synchronisiert wird. Dadurch kann das Preview-Component bei Änderungen im Editor automatisch aktualisiert werden, was eine Live-Vorschau der Änderungen ermöglicht. Damit das Two-Way-Binding funktioniert, muss zusätzlich ein \@Output-Parameter als EventEmitter definiert werden, der bei einer Änderung aufgerufen wird. 

#codeFigure("Two-Way-Binding", <twoWay>, "two-way")

Außerdem lädt das Edit-Component  für jede Sprache ein Translator-Component. 
Das Translator-Component hat die Aufgabe die benötigte Sprache zu laden und im Translations-Array an die erste Stelle zu schieben. Dies ist notwendig, weil in den folgenden Editor- und Preview-Komponenten immer auf den ersten Eintrag im Array geschaut wird. Wenn im Preview-Component beispielsweise der Name des Modules gezeigt werden soll, wird `module.translations[0].name` aufgerufen.

#imageFigure(<components>, "translator.svg", "Komponenten der Modulbearbeitung")

#heading("Automatische Vervollständigung von Eingaben", level: 4, numbering: none, outlined: false)<autocomplete>
Um die Eingabe in Textfeldern zu erleichern, wurden eine automatische Vervollständigung implementiert. In Textfeldern mit kurzen Texten (beispielsweise @exam) erscheint ein Vorschlag, sobald der User mit der Eingabe beginnt. Es werden Texte vorgeschlagen, die in anderen Modulen für das selbe Eingabefeld verwendet werden. Somit kann der User zum Einen selbstständig einen neuen Wert eintragen, oder alternativ einen vorgeschlagenen Wert auswählen, um nicht den gesamten Text immer wieder eingeben zu müssen.
In Textfeldern mit längeren Texten wurde dies nicht implementiert, da sich deren Inhalte nicht, oder nur sehr selten wiederholen (beispielsweise @literature).


#heading("Umwandlung von Textfeldern zu interaktiven Auswahl-Elementen", level: 4, numbering: none, outlined: false)
Des Weiteren wurden, wie bereits in @addModule konzipiert, einige Textfelder umgewandelt. In den ursprünglichen Daten, die für diese Arbeit vorlagen, bestanden alle Informationen aus Texten. Diese Informationen wurden teilweise umgewandet, um deren Eingaben zu vereinfachen. Ein Beispiel hierfür ist die verantwortliche Person (@responsible), welche zuvor in einem Textfeld abgelegt wurde. In der implementierten Oberfläche gibt es nun ein Dropdown, in dem aus einer Liste an Personen ausgewählt werden kann. Im Backend wird dann nur die Id der Person gespeichert, statt des gesamten Textes. Auf eine ähnliche Art wurden diverse weitere Felder umgewandelt, sodass bei der Eingabe nun weniger Fehler gemacht werden können. 



#heading("Plausibilitätschecks", level: 4, numbering: none, outlined: false)
Eingabgefehler können unentdeckt bleiben und sich somit mit der Zeit häufen. Um diesem Problem entgegenzuwirken, wurden (wie in @CHECKMOD gefordert) Plausibilitätschecks implementiert. Sobald alle Eingaben getätigt wurden, kann ein User per Klick auf "weiter" auf die nächste Seite wechseln. Bevor jedoch gewechselt wird, werden die eingebenen Daten überprüft. Fallen hierbei Umstimmigkeiten auf, wird der User darauf hingewiesen. Die entsprechenden Felder färben sich dann rot und zeigen in einem Tooltip den Grund dafür. Ein User kann nun entweder die Daten korrigieren, oder die Warnung ignorieren und das Modul dennoch abspeichern. Das System soll vermeindlich falsche Eingaben nicht vollständig verhindern, sondern nur darauf hinweisen, da davon ausgegangen wird, dass das System von Experten bedient werden.

Neben der Prüfung, ob in jedes Feld ein Wert eingegeben wurde, gibt es folgende Überprüfungen:

1. Felder, die wie #link(<autocomplete>)[oben] beschrieben eine Autovervollständigung haben, sollten einen Wert beinhalten, den es bereits gibt.
2. Die Abkürzung eines (Teil-) Moduls entspricht einem bestimmten Muster. Dieses wird mithilfe eines regulären Ausdruckes überprüft. Im Falle der Teilmodule wird dieser Ausdruck genutzt: `/^[A-Z]{3}-[0-9]{3}-[0-9]{2}$/`. Der eingegebene Abkürzung muss mit drei Großbuchstaben (A-Z) beginnen, gefolgt von einem Bindestrich, drei Ziffern (0-9), einem weiteren Bindestrich und muss schließlich zwei Ziffern enden. Zeichen davor oder danach sind auch nicht zulässig. @RegularExpressionsJavaScript2024
3. Die Abkürzung sollte eindeutig, also noch nicht vergeben sein.
4. Der angegebene Zeitaufwand (@hours) muss zu den angegebenen ECTS (@credits) passen. Ein ECTS entspricht laut StudAkkVO einem Zeitaufwand von 25 bis 30 Stunden. @studAkkVO
5. Das Feld Semester (@recommendedSemester) kann einen Bindestrich enthalten (z.B. 4-6). In dem Fall muss die zweite Zahl größer als die erste Zahl sein.





== Dokumentation <createDocumentation>

Das neue System hat mehrere Komponenten, die zum einen bei der Einführung des Systems installiert werden müssen und zum anderen in Zukunft weiterentwickelt werden müssen. Um diese beiden Aufgaben zu unterstützen, wurden einige Informationen im Rahmen einer Dokumentation zusammengetragen. Die Dokumentation besteht aus drei Abschnitten: Frontend, Backend und API. Die Abschnitte Frontend und Backend sind ähnlich aufgebaut. Beide enthalten Informationen zur erstmaligen Installation des Systems. Weiterhin ist beschrieben, wie neue Komponenten hinzugefügt werden können und was dabei zu beachten ist. Im Abschnitt API ist dahingegen beschrieben, wie die vom Backend bereitgestellte API genutzt werden kann, um verschiedene Datenabfragen durchzuführen. Kompliziertere Endpunkte sind hier außerdem aufgeführt. Es ist unter anderem beschrieben, wie der Login funktioniert und wie die Sprache der Antworten geändert werden kann.
Die Erstellung der Dokumentation lief parallel zur Entwicklung des Systems (@createBackend und @createFrontend). Um sicherzustellen, dass die wichtigsten Informationen bereitstehen, wurde anschließend das System erneut auf einem Testserver mithilfe der Anleitungen aus der Dokumentation installiert.

Die Texte sind im Markdown-Format verfasst, was bedeutet, dass sie von zahlreichen Editoren unterstützt werden. Zudem können die Plattformen GitHub und GitLab die Markdown-Dateien darstellen, wenn ein Entwickler dort den Quellcode durchsucht.

Zusätzlich zu der Möglichkeit, die Markdown-Dateien mit einem beliebigen Texteditor oder einer der genannten Plattformen zu lesen, wurde in dieser Arbeit zusätzlich das Framework Docusaurus 
@docusaurus genutzt, um aus den Markdown-Dateien eine Website zu generieren (@documentation). Diese Website kann genutzt werden um durch die vollständige Dokumentation in einer Benutzeroberfläche zu navigieren. Der Aufbau der Website sollte auf viele Entwickler bekannt wirken, da zahlreiche Open-Source-Projekte ihre Dokumentation mithilfe von Docusaurus realisieren. @DocusaurusSiteShowcase

Die Docusaurus-Website wurde überdies mit einer Suchfunktion erweitert, die von algolia bereitgestellt wird. @KISucheVersteht Auch diese Suchfunktion sollte Entwickelnden bekannt sein, da sie in vielen Dokumentationen genutzt wird. Die Suchfunktion kann mit der Tastenkombination Strg/Ctrl+K aufgerufen werden. In die Suchfunktion können beliebige Texte eingegeben werden, um schnell relevante Dokumentationsinhalte zu finden. Damit zu den Texten dann geeignete Vorschläge gemacht werden können (@docSearch), wird ein Crawler von algolia genutzt, welcher die Website in regelmäßigen Abständen indiziert. @CreateNewCrawler

#imageFigure(<documentation>, "../documentation.png", "Docusaurus-Website")

#imageFigure(<docSearch>, "../docSearch.png", "Suchfunktion der Dokumentation")


== Podman<podman>
Im letzten Schritt wurden alle Anwendungen für die Verwendung Podman @PodmanDesktopContainers vorbereitet. Podman erlaubt es, Anwendungen in Containern zu kapseln. Podman erinnert sehr stark an Docker @DockerAcceleratedContainer und nutzt ähnliche Befehle. Dieses System wurde mit Podman getestet, weil es in Zukunft auch mit Podman gehostet werden soll.

Um das neue System mit Podman bereitzustellen, sind einige Vorbereitungen nötig. Zunächst muss überlegt werden, welche Container benötigt werden. Für jede Anwendung soll ein eigener Container genutzt werden, um die Zuständigkeiten klar zu trennen. Dies bringt den Vorteil, dass einzelne Komponenten einfacher austauschbar sind, da sie über eine definierte Schnittstelle miteinander kommunizieren. Es wird für das Backend, das Frontend, die LaTeX-Api, das LaTeX-Poll-Script und die Dokumentation jeweils ein Container benötigt.

Im ersten Schritt musste nun in jedem Verzeichnis der soeben genannten Anwendungen ein Dockerfile erstellt werden, welches beschreibt, wie sich der Container verhalten soll. Aus dem Dockerfile wird später ein Image erstellt, mit dem der Container generiert werden kann. Das Image ist also die Vorlage für den Container. Für das Backend und die LaTeX-Api gab es bereits ein Dockerfile. Für die Dokumentation wurde das Dockerfile aus der Docusaurus-Dokumentation @DockerDeploymentDocusaurus2024 übernommen. Für das LaTeX-Poll-Skript und das neue Frontend wurden jeweils ein Dockerfile erstellt.

Im Dockerfile für das LaTeX-Poll-Skript (@latexDockerfile) ist ein einfaches Beispiel für ein Dockerfile zu sehen. In der ersten Zeile wird die Basis des Images festgelegt. @DockerfileReference0200 In diesem Fall wird für das Skript python benötigt, daher wird ein Python-Image als Basis verwendet. Es wurde eine Alpine Version des Python-Images ausgewählt. Die Alpine Version zeichnet sich dadurch aus, dass dessen Größe minimal gehalten wurde, indem nur die benötigten Werkzeuge (in diesem Fall python) installiert sind. @IndexAlpineLinux Des Weiteren wird in Zeile 6 ein benötigtes Package installiert, damit Http-Requests möglich sind. Abschließend wird dann noch ein Crontab installiert, welcher das Python-Skript in einem bestimmten Intervall regelmäßig ausführt.
#codeFigure("Docker File für das Latex-Poll-Skript", <latexDockerfile>, "latexDockerfile")


Das Dockerfile des Frontends ist komplexer. Es besteht aus zwei Stages. Die erste Stage basiert auf einem node-alpine-Image und ist für das Kompilieren des Quellcodes zuständig. Die zweite Stage (ab Zeile 15) ist als Webserver für die Bereitstellung der Website zuständig und benutzt das Image nginx:alpine als Basis, beinhaltet also einen Webserver.

Für das Builden in der ersten Stage wurde darauf geachtet, dass nicht direkt alle Dateien kopiert werden (Zeile 11). Stattdessen werden zunächst nur die package.json und die package-lock.json kopiert und ein npm ci ausgeführt um die Packages zu installieren. Dies hat den entscheidenen Vorteil, dass das Ergebnis gecacht werden kann. Docker arbeitet mit Layern, was in diesem Fall bedeutet, dass das Ergebnis nach dem Installieren der Packages in einem Layer abgespeichert wird. Dieses Layer kann nun beim Erneuten builden des Docker-Images aus dem Cache geladen werden (sofern sich die package.json nicht verändert hat). Hätten wir in Zeile 7 direkt alle Dateien in das Image geladen, müssten wir bei jedem build des Images erneut die Abhängigkeiten installieren, was zu einer erhöhten Laufzeit des Buildvorganges führen würde. @DockerBuildCache 

Damit die Ergebnisse aus der ersten Stage in der zweiten Stage genutzt werden können, werden diese mithilfe des Copy-Befehls in Zeile 16 kopiert. Die Flag `--from` gibt an, dass aus der vorherigen Stage kopiert werden soll.
#codeFigure("Dockerfile für das Frontende", <frontendDockerfile>, "FrontendDockerfile")


Nachdem nun alle Dockerfiles bereitstehen, können die Images erstellt werden. Der Befehl `podman build -t studymodules-documentation .` erstellt beispielsweise das Image für die Dokumentation. Damit aus den Images nun Container generiert werden können, wurde eine compose-Datei erstellt (@compose). In dieser ist beschrieben, wie die Container konfiguriert sein sollen. Alle Container werden zur besseren Übersicht in einer Gruppe names "studymodules_project" gruppiert. Der Container latex-poll-script ist am einfachsten zu erklären. Bei diesem ist lediglich das Image angegeben, auf dem er basiert. Da er lediglich zwischen Backend und latex-api vermittelt, sind keine weiteren Konfigurationen notwenig.

Für die anderen Container ist mehr Konfigurationsaufwand nötig. Hier muss zum Beispiel noch das Port-Mapping gesetzt werden. Hierbei wird ein Port der innerhalb des Containers existiert auf einen Port der ausßerhalb des Containers existiert gemappt. Im Fall vom Backend wird beispielsweise der Port 3000 aus dem Container nach außen als Port 3000 freigegeben. Somit ist das Backend auf Port 3000 erreichbar. Bei der LaTeX-Api wurde der Port 8080 aus dem Container nach außen als Port 2345 freigegeben, da Port 8080 bereits für die Dokumentation belegt war. Auf dem Server, auf dem die Docker-Container laufen ist die LaTeX-Api nun also unter dem Port 2345 zu erreichen. Allerdings gibt es einen Fallstrick: Das latex-poll-script soll auf die LaTeX-Api zugreifen. Dies funktioniert allerdings innerhalb des Containers latex-poll-script nicht über den Port 2345. Stattdessen hier als URL der Name des Containers verwendet, auf den zugegriffen wurde und als Port der Port innerhalb des Containers. Um also vom Poll-Skript auf die Api zuzugreifen, muss diese URL aufgerufen werden: latex-api:8080.

Das Backend benötigt außerdem eine Möglichkeit, Daten langfristig aufzubewahren. Bei einem Update des Images muss der Container des Backends neu erstellt werden, sodass darin enthaltene Daten verloren gehen. Um dieses Problem zu umgehen, können Volumes genutzt werden. @VolumesDockerDocs In der Compose-Datei ist in Zeile 20 zu sehen, wie eine Volume definiert wird. Hierzu wird einfach ein Ordner vom Hostsystem auf einen Ordner innerhalb des Containers gemappt. Beide Ordner werden automatisch synchronisiert. Wenn ein Container zerstört wird, bleibt die Volume bestehen und kann für den nächsten Container weiterverwendet werden. Als zusätzlichen Vorteil kann nun auch vom Hostsystem auf die Dateien in der Volume zugegriffen werden. In der Volume wird beispielsweise der Inhalt der Datenbank aufbewahrt.

Nachdem die Images nun erstellt sind und die Compose-Datei die Struktur der Container definiert kann `podman compose up -d` ausgeführt werden, um die Container zu erstellen und zu starten. In der Desktopanwendung von podman ist dies nachzuvollziehen:

#imageFigure(<a>, "podman.png", "Podman Desktop")



== Zwischenfazit
Nachdem Frontend und Backend implementiert wurden und eine Dokumentation erstellt wurde, besteht nun eine erste lauffähige Version des Systems. Diese Version kann im folgenden @review verschiedenen Personen vorgestellt und anschließend evaluiert werden.