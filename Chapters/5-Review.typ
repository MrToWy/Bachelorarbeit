#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *






= Review <review>
In diesem Kapitel wird das erstellte System überprüft. Es soll herausgefunden werden, ob das neue System einsetzbar ist. Hierzu wird ein Interview geführt und die in @anforderungsanalyse aufgestellten Anforderungen überprüft. 





== Interview mit Modulverantwortlicher Person
Im Laufe der Implementierungsphase wurde ein Prototyp einer modulverantwortlichen Person vorgestellt, um einschätzen zu können, ob das entstehende System eine Erleichterung des bisherigen Arbeitsprozesses darstellen könnte. Aus dem Interview ergaben sich kleinere Anpassungen an den Anforderungen, jedoch konnten keine groben Fehler am Gesamtsystem festgestellt werden. Ergebnis des Interviews war, dass die Anwendung benutzbar wirkt und den Arbeitsprozess vermutlich verbessern wird.


== Abweichungen zum Prototypen
Um sicherzustellen, dass keine wichtigen Details aus den Entwürfen übersehen wurden, wurde das neue System in diesem Abschnitt mit den Entwürfen aus @UI verglichen.

Das in @drawer gezeigte Menü enthält in der tatsächlichen Implementierung andere Einträge. Es gibt beispielsweise in der aktuellen Version des Systems noch keine Möglichkeit, einen neuen Studiengang oder eine neue Abteilung anzulegen. Dies muss aktuell noch per Datenbankzugriff erledigt werden. Da das System im ersten Schritt jedoch nur von der Abteilung Informatik genutzt werden soll, ist dies zunächst in Ordnung. Eine Implementierung entsprechender Funktionen sollte zudem nicht aufwändig sein, da es bereits ähnliche Implementierungen für das Erstellen von Modulen und Teilmodulen gibt. Des Weiteren entfällt die geplante Benutzerverwaltung (@createUser), da in Zukunft eventuell direkt das LDAP der Hochschule verwendet werden könnte. Stattdessen gibt es im Drawer jetzt die Möglichkeit, PDF-Kompilierungsanträge und Teilmodule zu verwalten. 


Die Filter in @moduleoverview wurden direkt in die Tabellenüberschrift integriert (@filterResult). Außerdem wurden weitere Spalten eingeführt, um #link(<UseCaseInfoModule>)[Use Case 2] abbilden zu können.

#imageFigure(<filterResult>, "../Images/filter.png", "Filtermöglichkeit")

Die in @translateDropdown und @translatePopup zu sehenden Steuerelemente zum Hinzufügen von Übersetzungen wurden zugunsten einer besseren Usability ersetzt (siehe @createEditModules)

Alle nicht genannten Abbildungen aus @UI ähneln den tatsächlichen Implementierungen.

Bei dem Vergleich sind keine unerklärten Abweichungen gefunden worden. Alle vorgenommenen Änderungen verbessern entweder das System oder sind nicht für die Erfüllung der wesentlichen Use Cases erforderlich, sodass davon ausgegangen wird, dass alle wichtigen Anforderungen an das Design erfüllt wurden.


== Vergleich der PDFs<pdfComparision>
Da die Generierung eines Modulhandbuchkataloges im PDF-Format ein zentraler Bestandteil dieser Arbeit war, sollte das Ergebnis genauer geprüft werden. Hierzu wurden aktuelle Modulhandbücher von der Website der Hochschule mit den neu generierten Handbüchern aus dem System verglichen. Bei der ersten Überprüfung (siehe @pdfA und @pdfB @ilovepdf.comILovePDFOnlinePDF) sind dabei noch einige Aufgaben aufgefallen, die im Anschluss behoben wurden. So fehlten beispielsweise bei den Semesterwochenstunden ein Komma und das Suffix "SWS". Bei den längeren Texten (z. B. "Inhalt") fällt außerdem auf, dass die neuen Texte im Blocksatz dargestellt sind, während die ursprünglichen Texte lediglich linksbündig ausgerichtet sind. 

#imageFigure(<pdfA>, "PdfCompareA.png", "Ursprüngliches PDF")

#imageFigure(<pdfB>, "PdfCompareB.png", "Neues PDF")

Nachdem die kleineren Anpassungen vorgenommen und mit einer erneuten Überprüfung verifiziert wurden, ähnelt das neue PDF nun dem ursprünglichen PDF. Die Nutzung des neuen PDFs sollte dementsprechend möglich sein. 










== Überprüfung, ob Anforderungen erfüllt sind

Im Folgenden wird überprüft, welche Anforderungen erfüllt sind und welche Anforderungen in Zukunft noch umgesetzt werden müssen. Dies hilft für die spätere Einschätzung, ob das System bereits eingeführt werden könnte, oder ob es noch kritische offene Aufgaben gibt. Die Anforderungen enthalten gegebenenfalls einen Verweis auf Abbildungen oder Passagen im vorangegangenen Text, um die aufgestellten Behauptungen zu beweisen.


#table(
  columns: 3,
  table.header(
    [*Anf.*], [*Umsetzung*], [*Bewertung*],
  ),

  table.cell(colspan: 3, align: center, [#link(<UseCaseInfoDegree>)[#emph("Use Case 1")]]),
  [@StaticLink], [Durch die Nutzung von Routen kann ein Studiengang mithilfe eines Links aufgerufen werden.], [Erfüllt #linebreak() @appRoutes],
  [@PDF], [In der Übersicht aller Studiengänge der Abteilung kann ein PDF für jeden Studiengang aufgerufen werden. ], [Erfüllt #linebreak() @degreeProgramOverview],
  
  table.cell(colspan: 3, align: center, [#emph("Use Case 2")]),
  [@SHOWMODULES], [Es können alle Module eines Studienganges angezeigt werden.], [Erfüllt #linebreak() @moduleOverviewResult],
  [@FILTER], [In allen Spalten steht eine Filterfunktion bereit.], [Erfüllt #linebreak() @filterResult],
  [@SEARCH], [Die Suchfunktion wurde erfolgreich implementiert.], [Erfüllt #linebreak() @implementSearch],
  [@SHOWMODULEDETAIL], [Es gibt für jedes Modul eine Detailansicht mit allen verfügbaren Informationen.], [Erfüllt #linebreak() @moduleDetailResult],

  table.cell(colspan: 3, align: center, [#emph("Use Case 3")]),
  [@LOGIN], [Im seitlichen Menü gibt es einen Login-Button.], [Erfüllt],
  [@LOGOUT], [Im seitlichen Menü gibt es einen Logout-Button.], [Erfüllt],
  [@RESETPW], [Wurde nicht umgesetzt, da Accounts in der Einführungsphase erst direkt in der Datenbank verwaltet werden. Eventuell erfolgt später eine Anbindung an die SSO-Accounts der Hochschule. <nichtUmgesetzt>], [Nicht erfüllt],
  [@RESETMYPW], [Wurde nicht umgesetzt (siehe #link(<nichtUmgesetzt>)[Umsetzung F9])], [Nicht erfüllt],
  [@EDIT], [Personen die für ein Modul verantwortlich sind, sowie die studiengangsverantwortliche Person können Module bearbeiten.], [Erfüllt #linebreak() @editModule],
  [@CHECKMOD], [Es wurden verschiedene Plausibilitätschecks eingebaut. Fehlerhafte Felder werden rot markiert. Der User erhält weitere Informationen über einen Tooltip.], [Erfüllt #linebreak() @plausib],

  table.cell(colspan: 3, align: center, [#emph("Use Case 4")]),
  [@MODULE], [Module können bearbeitet werden.], [Erfüllt  #linebreak() @editModule],
  [@DUPLICATE], [Wurde aus zeitlichen Gründen nicht priorisiert.], [Nicht erfüllt],
  [@COURSE], [Studiengänge können verwaltet werden], [Erfüllt  #linebreak() @menu],
  [@DUPLICATECourse], [Studiengänge können dupliziert werden. Dabei werden darin enthaltene Module und Teilmodule ebenfalls dupliziert. Ansprechpartner werden nicht dupliziert, sondern auf die bestehenden Einträge verwiesen.], [Erfüllt #linebreak() @menu],
  [@hideCourse], [Studiengänge können im Menü in der Abteilungsübersicht ausgeblendet werden.], [Erfüllt #linebreak() @menu],
  [@showHiddenCourses], [Wenn ein User angemeldet ist, werden ausgeblendete Studiengänge angezeigt. Die für nicht angemeldete User ausgeblendeten Studiengänge erhalten eine Markierung, die darauf hinweist. ], [Erfüllt #linebreak() @hiddenCourse],
  [@CRUSER], [Wurde nicht umgesetzt (siehe #link(<nichtUmgesetzt>)[Umsetzung F9])], [Nicht erfüllt],
  [@CreateSubmodules], [Teilmodule können verwaltet werden. ], [Erfüllt],
  [@CreateRequirements], [Vorraussetzungen haben keine eigenständige Verwaltungsmaske, sondern sind ein Teil der Modulbearbeitungsmaske und können dort bearbeitet werden. ], [Erfüllt],

  table.cell(colspan: 3, align: center, [#emph("Use Case 5")]),
  [@SHOWCHANGES], [Die Änderungen an einem Modul werden automatisch protokolliert. Dabei ist der Benutzer angegeben, sowie alle modifizierten Felder.], [Erfüllt #linebreak() @changelog #linebreak() #link(<implementChangelog>)[Unterabschnitt 4.1.2]],
  [@REVERT], [Wurde aus zeitlichen Gründen nicht priorisiert.], [Nicht erfüllt],
  [@SHOWCHANGESmisc], [Wurde aus zeitlichen Gründen nicht priorisiert.], [Nicht erfüllt],
  [@REVERTmisc], [Wurde aus zeitlichen Gründen nicht priorisiert.], [Nicht erfüllt],

  table.cell(colspan: 3, align: center, [#emph("Use Case 6")]),
  [@COMPARE], [Wurde aus zeitlichen Gründen nicht priorisiert.], [Nicht erfüllt],
)

#imageFigure(<hiddenCourse>, "../Images/HiddenCourse.png", "Ausgeblendeter Studiengang")

#imageFigure(<changelog>, "../Images/Changelog.png", "Änderungshistorie")

#pagebreak()
#table(
  columns: 3,
  table.header(
    [*Anf.*], [*Umsetzung*], [*Bewertung*],
  ),
  
  table.cell(colspan: 3, align: center, [#emph("Änderbarkeit")]),
  [@MODULAR], [Frontend und Backend nutzen wiederverwendbare Services (z. B. UserService zum Abrufen der Daten aller User). Außerdem gibt es im Frontend wiederverwendbare Komponenten (z. B. ResponsibleAvatarComponent)], [Erfüllt],
  [@TESTABLE], [Durch Erfüllung der Anforderungen @MODULAR, @Verantwortlichkeit, @Kopplung, @Komplex und @DepedencyInjection sollte der vorliegende Code gut testbar sein, sodass die Anforderungen @TEST und @TESTUI umgesetzt werden können.], [Erfüllt],
  [@Verantwortlichkeit], [Bei der Entwicklung wurde darauf geachtet, dass es für die verschiedenen Arten von Daten jeweils eigene Services gibt. Es gibt nicht eine große Klasse "DatabaseAccess", sondern einen ModuleService, einen SubModuleService, einen RequirementService und so weiter.], [Erfüllt],
  [@Kopplung], [Aus der Trennung von Frontend und Backend ergibt sich eine lose Kopplung, da das Frontend keine Abhängigkeit zur Datenbank hat, weil nur über die REST-Schnittstellte kommuniziert wird. Außerdem kommen die meisten Komponenten im Quellcode mit einer geringen Anzahl an Abhängigkeiten aus. Als Beispiel ist hier das ModuleGridComponent zu nennen, welches als zentrales Element der Anwendung die Module in einer Tabelle auf der Oberfläche anzeigt. Diese Komponente hat Abhängigkeiten zum ModuleService (um alle Module abzurufen), zum Router, der Activated Route und dem CourseService (um den ausgewählten Studiengang aus der URL auslesen und dessen Namen anzeigen zu können), zum AuthService (um zu ermitteln, ob der User eingeloggt ist) und zum LanguageService (um die Website in der gewünschten Sprache zu zeigen). Diese Anzahl an Abhängigkeiten ist gerechtfertigt, weil die Komponente eine zentrale Rolle in der Anwendung spielt und daher mit verschiedenen Bereichen der Anwendung interagieren muss.], [Erfüllt],
  [@Komplex], [Mithilfe eines externen Tools (Qodana @QodanaStaticCode) wurde die zyklomatische Komplexität der einzelnen Methoden betrachtet. Hierbei wurden keine Methoden mit einer höheren Komplexität als 10 gefunden.], [Erfüllt],
  [@DepedencyInjection], [In Frontend und Backend werden Abhängigkeiten mithilfe von Dependency Injection eingesetzt. Siehe @createEndpoints und @uebersetzbarkeit], [Erfüllt],
  [@TEST], [Bisher nicht umgesetzt, aber durch @TESTABLE vorbereitet.], [Vorbereitet],
  [@TESTUI], [Bisher nicht umgesetzt, aber durch @TESTABLE vorbereitet.], [Vorbereitet],
  table.cell(colspan: 3, align: center, [#emph("Benutzbarkeit")]),
  [@PATH], [Der aktuelle Pfad wird in der Anwendung angezeigt (siehe @moduleDetailResult). Durch Anklicken eines Elementes kann zurückgesprungen werden (beispielsweise von der Detailansicht eines Moduls zurück zur Auflistung aller Module)], [Erfüllt],
  [@ASK], [Das Löschen von Datensätzen muss vom User bestätigt werden. Hierzu erscheint ein Popup mit den Buttons "Ja" und "Nein".], [Erfüllt],
  [@SOFTDELETE], [Diese Anforderung wurde nicht umgesetzt. Das Löschen eines Datensatzes könnte in Zukunft angepasst werden, sodass nur eine Eigenschaft "deleted" auf True gesetzt wird. Beim Laden von Daten werden nur Datensätze geladen, die "deleted=false" sind. Die Oberfläche könnte angepasst werden, sodass angemeldete User auch gelöschte Elemente ansehen können.], [Konzept liegt vor],
  [@QUICK], [Das Generieren eines PDFs dauert recht lange. Hier wird ein Statusindikator eingesetzt, der dem User anzeigt, in welchem Status sich der Kompilierungsauftrag befindet. Abgesehen davon gibt es keine Stellen in der Anwendung, die eine erhöhte Ladezeit haben. Ein Ladebalken wurde daher nicht eingebaut, das Ziel einer guten Benutzbarkeit aber trotzdem erreicht.], [Erfüllt],
  [@ERROR], [Mögliche Fehler werden abgefangen und mithilfe einer verständlichen Fehlermeldung an den User übermittelt.], [Erfüllt #linebreak() @errorMsg],
  [@ERRORSOLVE],[Bisher nicht umgesetzt, aber durch @ERROR vorbereitet.],[Vorbereitet],
  [@RESPONSIVE],[Die Übersicht der Studiengänge, aller Module und die Moduldetails wurden für mobile Endgeräte optimiert.],[Teilweise erfüllt #linebreak() @design],
  [@KEYBOARD],[Wurde aus zeitlichen Gründen nicht priorisiert.], [Nicht erfüllt],
  [@SELFEXPLAIN],[Ohne eine Studie oder ähnliches ist es schwer zu beweisen, dass das System selbsterklärend ist. In der Implementierung wurde darauf geachtet, möglichst selbsterklärende Beschriftungen, Icons und Steuerelemente zu verwenden. In den Bearbeitungsmasken gibt es eine Live-Vorschau, sodass ersichtlich ist, welches Eingabefeld was verändert. Außerdem wurden an verschiedenen Stellen Tooltips, Dialoge und Einblendungen verwendet, um möglicherweise unklare Details genauer zu erklären.],[Vermutlich erfüllt],
  
  table.cell(colspan: 3, align: center, [#emph("Effizienz")]),
  [@STARTFRONTEND],[Alle Seiten im Frontend laden innerhalb einer Sekunde. Die geladenen Datenmengen werden reduziert, indem beim Laden der Modulübersicht zum Beispiel nicht direkt alle Informationen eines Moduls geladen werden. Diese werden erst geladen, sobald die Detailansicht geöffnet wird.],[Erfüllt],
  [@STARTBACKEND],[Während der Implementierung des Systems konnte kein Zustand ermittelt werden, zu dem das Backend nach einem Fehler nicht innerhalb einer Minute neu startet.],[Erfüllt],
  [@DEPLOY],[Das Frontend wird mithilfe einer GitHub-Action bei jedem Push auf den Testserver deployt. Das Backend wird mithilfe eines Deploy-Skripts und einem Cronjob automatisch deployt. Diese Methodik ist auch für den Livebetrieb möglich.],[Vorbereitet],
  [@CLICKS],[Es wurde versucht, die Arbeitsabläufe möglichst einfach zu gestalten. Ohne größeren Aufwand ist es nicht nachprüfbar, ob diese Anforderung vollständig erledigt ist.],[Vermutlich erfüllt],

  table.cell(colspan: 3, align: center, [#emph("Funktionalität")]),
  [@TRANSLATE],[Die Anwendung und die PDFs die generiert werden stehen in Englisch und Deutsch bereit.],[Erfüllt],
  [@TRANSLATEMULTIPLE],[Der Code ist so vorbereitet, dass ohne großen Aufwand weitere Sprachen hinzugefügt werden können. Aktuell liegen die Modulhandbücher nur in Englisch und Deutsch vor, weshalb die neue Anwendung auch nur in Deutsch und Englisch entwickelt wurde.],[Vorbereitet],
  [@lookup],[In den Bearbeitungsmasken werden Eingabefelder verwendet, welche den User bei der Eingabe unterstützen. Wenn beispielsweise eine Zahl erwartet wird, können keine Buchstaben eingegeben werden. Außerdem werden, wenn möglich, Dropdowns statt Textfeldern genutzt.],[Erfüllt #linebreak() @editModule],
  [@similarPdf], [Das neue PDF ähnelt dem bisherigen PDF.], [Erfüllt #linebreak() @pdfComparision],
  [@security], [Nur autorisierte Benutzer können datenverändernde Endpunkte verwenden.], [Erfüllt],

  table.cell(colspan: 3, align: center, [#emph("Übertragbarkeit")]),
  [@DOKBACK], [Es gibt eine Dokumentation, welche unter anderem erklärt, wie das System einzurichten ist.], [Erfüllt #linebreak() @createDocumentation],
  [@containerAnf], [Das neue System kann mithilfe von Podman-Containern deployt werden.], [Erfüllt #linebreak() @podman],
  [@austauschbarkeit], [Durch die Verwendung von Prisma ist der Zugriff auf die Datenbank abstrahiert, daher kann die tatsächliche Datenbank ohne größeren Aufwand ausgetauscht werden. Der LaTeX-Kompilierungs-Server wird über einen einzelnen REST-Endpunkt angesprochen und ist dadurch nur sehr lose gekoppelt. Das Frontend arbeitet hingegen mit mehreren REST-Endpunkten des Backends und ist daher zwar austauschbar, jedoch wäre das verglichen mit den zuvor genannten Komponenten aufwändig.], [Erfüllt],

  table.cell(colspan: 3, align: center, [#emph("Zuverlässigkeit")]),
  [@ERRORSTABLE], [Fehler die während des Testens aufgefallen sind, haben die Systeme nicht zum Absturz gebracht.], [Vermutlich erfüllt],
  [@reife], [Beim Erledigen der Use Cases sind keine Fehler aufgefallen.], [Erfüllt],
  [@robustheit], [Wurde aus zeitlichen Gründen nicht priorisiert.], [Nicht erfüllt],

  table.cell(colspan: 3, align: center, [#emph("Technische Anforderungen")]),
  [@FRONT], [Das Frontend ist eine neue Anwendung.], [Erfüllt],
  [@FRONT_TECH], [Das Frontend nutzt Angular.], [Erfüllt],
  [@BACK], [Das bestehende Backend wurde erweitert.], [Erfüllt],
  [@BACK_TECH], [Das Backend nutzt (weiterhin) NestJS und Prisma.], [Erfüllt],
  [@DB], [Die bestehende Datenbank wurde erweitert.], [Erfüllt],
  
)



#imageFigure(<errorMsg>, "../Images/errormsg.png", "Fehlermeldung vom error.service.ts")








== Zwischenfazit
Nachdem die aufgestellten Anforderungen überprüft wurden, kann nun eine Aussage zum neuen System getroffen werden. 

Von den 64 Anforderungen wurden 15 Anforderungen nicht erfüllt. Unter den nicht erfüllten Anforderungen befinden sich keine Anforderungen mit dem Schlüsselwort "muss". Es wurden also alle Anforderungen, die für das System zwingend erforderlich sind, erfüllt. Aus diesem Grund ist davon auszugehen, dass das System für die in @usecases erstellten Use Cases nutzbar ist (mit Ausnahme des nur teilweise erfüllten #link(<UCRevertChanges>)[Use Case 5] und des ausgelassen #link(<UseCaseTable>)[Use Case 6]).



#pagebreak()
