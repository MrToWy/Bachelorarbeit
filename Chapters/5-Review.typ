#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *






= Review <review>
In diesem Kapitel wird das erstellte System überprüft. Hierzu werden zunächst Interviews durchgeführt um anschließend die in @anforderungsanalyse aufgestellten Anforderungen zu überprüfen. Abschließend gibt es ein Fazit und einen kleinen Ausblick.

== Interview mit Modulverantwortlicher Person


== Interview mit zukünftigem Dekan 

== Abweichungen zum Prototypen

== Überprüfung, ob Anforderungen erfüllt sind

Im Folgenden wird überprüft, welche Anforderungen erfüllt sind und welche Anforderungen in Zukunft noch umgesetzt werden müssen.


#table(
  columns: 3,
  table.header(
    [*Anf.*], [*Umsetzung*], [*Bewertung*],
  ),

  table.cell(colspan: 3, align: center, [#link(<UseCaseInfoDegree>)[#emph("Use-Case 1")]]),
  [@StaticLink], [Durch die Nutzung von Routen kann ein Studiengang mithilfe eines Links aufgerufen werden.], [Erfüllt #linebreak() (@appRoutes)],
  [@PDF], [In der Übersicht aller Studiengänge der Abteilung kann ein Pdf für jeden Studiengang aufgerufen werden. ], [Erfüllt #linebreak() (@degreeProgramOverview)],
  
  table.cell(colspan: 3, align: center, [#emph("Use-Case 2")]),
  [@SHOWMODULES], [Es können alle Module eines Studienganges angezeigt werden.], [Erfüllt #linebreak() (@moduleOverviewResult)],
  [@FILTER], [In allen Spalten steht eine Filterfunktion bereit.], [Erfüllt #linebreak() (@filterResult)],
  [@SEARCH], [], [],
  [@SHOWMODULEDETAIL], [Es gibt für jedes Modul eine Detailansicht mit allen verfügbaren Informationen.], [Erfüllt #linebreak() (@moduleDetailResult)],

  table.cell(colspan: 3, align: center, [#emph("Use-Case 3")]),
  [@LOGIN], [Im seitlichen Menü gibt es einen Login-Button.], [Erfüllt],
  [@LOGOUT], [Im seitlichen Menü gibt es einen Logout-Button.], [Erfüllt],
  [@RESETPW], [Wurde nicht umgesetzt, da Accounts in der Einführungsphase erst direkt in der Datenbank verwaltet werden. Eventuell erfolgt später eine Anbindung an die SSO-Accounts der Hochschule. <nichtUmgesetzt>], [Nicht erfüllt],
  [@RESETMYPW], [Wurde nicht umgesetzt (siehe #link(<nichtUmgesetzt>)[Umsetzung F9])], [Nicht erfüllt],
  [@EDIT], [Module können bearbeitet werden.], [Erfüllt #linebreak() (@editModule)],
  [@CHECKMOD], [Es wurden verschiedene Plausibilitätschecks eingebaut. Fehlerhafte Felder werden rot markiert. Der User erhält weitere Informationen über einen Tooltip.], [Erfüllt #linebreak() (@plausib)],

  table.cell(colspan: 3, align: center, [#emph("Use-Case 4")]),
  [@MODULE], [], [],
  [@DUPLICATE], [], [],
  [@COURSE], [Studiengänge können verwaltet werden], [Erfüllt  #linebreak() (@menu)],
  [@DUPLICATECourse], [Studiengänge können dupliziert werden. Dabei werden darin enthaltene Module und Teilmodule ebenfalls dupliziert. Ansprechpartner werden nicht dupliziert, sondern auf die bestehenden Einträge verwiesen.], [Erfüllt #linebreak() (@menu)],
  [@hideCourse], [Studiengänge können im Menü in der Abteilungsübersicht ausgeblendet werden.], [Erfüllt #linebreak() (@menu)],
  [@showHiddenCourses], [Wenn ein User angemeldet ist, werden ausgeblendete Studiengänge angezeigt. Die für nicht angemeldete User ausgeblendeten Studiengänge erhalten eine Markierung die darauf hinweist. ], [Erfüllt #linebreak() @hiddenCourse],
  [@CRUSER], [Wurde nicht umgesetzt (siehe #link(<nichtUmgesetzt>)[Umsetzung F9])], [Nicht erfüllt],
  [@CreateSubmodules], [], [],
  [@CreateRequirements], [], [],

  table.cell(colspan: 3, align: center, [#emph("Use-Case 5")]),
  [@SHOWCHANGES], [], [],
  [@REVERT], [], [],
  [@SHOWCHANGESmisc], [], [],
  [@REVERTmisc], [], [],

  table.cell(colspan: 3, align: center, [#emph("Use-Case 6")]),
  [@COMPARE], [Wurde aus zeitlichen Gründen nicht priorisiert.], [Nicht erfüllt],
)

#pagebreak()
#table(
  columns: 3,
  table.header(
    [*Anf.*], [*Umsetzung*], [*Bewertung*],
  ),
  
  table.cell(colspan: 3, align: center, [#emph("Änderbarkeit")]),
  [@MODULAR], [Frontend und Backend nutzen wiederverwendbare Services (z.B. UserService zum Abrufen der Daten aller User). Außerdem gibt es im Frontend wiederverwendbare Komponenten (z.B. ResponsibleAvatarComponent)], [Erfüllt],
  [@TESTABLE], [Durch Erfüllung der Anforderungen @MODULAR, @Verantwortlichkeit, @Kopplung, @Komplex und @DepedencyInjection sollte der vorliegende Code gut testbar sein, sodass die Anforderungen @TEST und @TESTUI umgesetzt werden können.], [Erfüllt],
  [@Verantwortlichkeit], [Bei der Entwicklung wurde darauf geachtet, dass es für die verschiedenen Arten von Daten jeweils eigene Services gibt. Es gibt nicht eine große Klasse "DatabaseAccess", sondern einen ModuleService, einen SubModuleService, einen RequirementService und so weiter.], [Erfüllt],
  [@Kopplung], [Aus der Trennung von Frontend und Backend ergibt sich eine lose Kopplung, da das Frontend keine Abhängigkeit zur Datenbank hat, weil nur über die REST-Schnittstellte kommuniziert wird. Außerdem kommen die meisten Komponenten im Quellcode mit einer geringen Anzahl an Abhängigkeiten aus. Als Beispiel ist hier das ModuleGridComponent zu nennen, welches als zentrales Element der Anwendung die Module in einer Tabelle auf der Oberfläche anzeigt. Diese Komponente hat Abhängigkeiten zum ModuleService (um alle Module abzurufen), zum Router (um den ausgewählten Studiengang aus der URL auslesen zu können), zum AuthService (um zu ermitteln, ob der User eingeloggt ist) und zum LanguageService (um die Website in der gewünschten Sprache zu zeigen)], [Erfüllt],
  [@Komplex], [Mithilfe eines externen Tools wurde die zyklomatische Komplexität der einzelnen Methoden betrachtet. Hierbei wurden keine Methoden mit einer höheren Komplexität als 10 gefunden.], [Erfüllt],
  [@DepedencyInjection], [In Frontend und Backend werden Abhängkeiten mithilfe von Dependency Injection eingesetzt. Siehe @createEndpoints und @uebersetzbarkeit], [Erfüllt],
  [@TEST], [Bisher nicht umgesetzt, aber durch @TESTABLE vorbereitet.], [Vorbereitet],
  [@TESTUI], [Bisher nicht umgesetzt, aber durch @TESTABLE vorbereitet.], [Vorbereitet],
  table.cell(colspan: 3, align: center, [#emph("Benutzbarkeit")]),
  [@PATH], [Der aktuelle Pfad wird in der Anwendung angezeigt (siehe @moduleDetailResult). Durch Anklicken eines Elementes kann zurückgesprungen werden (Beispielsweise von der Detailansicht eines Moduls zurück zur Auflistung aller Module)], [Erfüllt],
  [@ASK], [Das Löschen von Datensätzen muss vom User bestätigt werden. Hierzu erscheint ein Popup mit den Buttons "Ja" und "Nein".], [Erfüllt],
  [@SOFTDELETE], [Diese Anforderung wurde nicht umgesetzt. Das Löschen eines Datensatzes könnte in Zukunft angepasst werden, sodass nur eine Eigenschaft "deleted" auf True gesetzt wird. Beim Laden von Daten werden nur Datensätze geladen, die "deleted=false" sind. Die Oberfläche könnte angepasst werden, sodass angemeldete User auch gelöschte Elemente ansehen können.], [Konzept liegt vor],
  [@QUICK], [Das Generieren eines Pdfs dauert recht lange. Hier wird ein Statusindikator eingesetzt, der dem User anzeigt, in welchem Status sich der Kompilierungsauftrag befindet. Abgesehen davon gibt es keine Stellen in der Anwendung, die eine erhöhte Ladezeit haben. Ein Ladebalken wurde daher nicht eingebaut, das Ziel einer guten Benutzbarkeit aber trotzdem erreicht.], [Erfüllt],
  [@ERROR], [Mögliche Fehler werden abgefangen und mithilfe einer verständlichen Fehlermeldung an den User übermittelt.], [Erfüllt],
  [@ERRORSOLVE],[],[],
  [@RESPONSIVE],[],[],
  [@KEYBOARD],[],[],
  [@SELFEXPLAIN],[],[],
  
  table.cell(colspan: 3, align: center, [#emph("Effizienz")]),
  [@STARTFRONTEND],[],[],
  [@STARTBACKEND],[],[],
  [@DEPLOY],[],[],
  [@CLICKS],[],[],

  table.cell(colspan: 3, align: center, [#emph("Funktionalität")]),
  [@TRANSLATE],[Die Anwendung und die Pdfs die generiert werden stehen in Englisch und Deutsch bereit.],[Erfüllt],
  [@TRANSLATEMULTIPLE],[Der Code ist so vorbereitet, dass ohne großen Aufwand weitere Sprachen hinzugefügt werden können. Aktuell liegen die Modulhandbücher nur in Englisch und Deutsch vor, weshalb die neue Anwendung auch nur in Deutsch und Englisch entwickelt wurde.],[Vorbereitet],
  [@lookup],[In den Bearbeitungsmasken werden Eingabefelder verwendet, welche den User bei der Eingabe unterstützen. Wenn beispielsweise eine Zahl erwartet wird, können keine Buchstaben eingegeben werden. Außerdem werden wenn möglich Dropdowns statt Textfeldern genutzt.],[Erfüllt #linebreak() (@editModule)],
)

#pagebreak()
== Fazit

Im Rahmen dieser Bachelorarbeit sollte der Prozess der Bearbeitung des Modulkataloges verbessert werden. Die hierzu aufgestellten Anforderungen wurden größtenteils erfüllt. Unter den nicht erfüllten Anforderungen befinden sich keine Anforderungen, die die produktive Nutzung der Anwendung verhindern. Zwar wäre es gut, wenn die ausstehenden Arbeiten in Zukunft umgesetzt werden, jedoch kann mit dem bestehenden System bereits der aktuell bestehende Arbeitsablauf ersetzt werden. Das System ermöglicht das Anzeigen von Modulkatalogen im PDF-Format und das Anzeigen von Moduldetails in einer modernen Oberfläche. Außerdem können die Informationen der Module im System bearbeitet werden, wobei das System mithilfe von Dropdowns und Plausibilitätschecks unterstützt. Das resultierende Pdf wird automatisch generiert und den Interessierten zur Verfügung gestellt. Außerdem sind wesentliche Informationen zur Einrichtung und Weiterentwicklung des Systems in einer Dokumentation erfasst.

== Ausblick

Für die Zukunft ist es denkbar, dass abgesehen von den bereits erfassten nicht erfüllten Anforderungen weitere Funktionen geplant werden. So könnte die moderne Anzeige von einzelnen Modulen um verschiedene Informationen erweitert werden. Es könnte beispielsweise eine Anbindung an den Stundenplan geben, sodass auf der Modulseite auch angezeigt wird, zu welchen Zeiten und an welchem Ort die Lehrveranstaltungen stattfinden. Auch wäre die Anbindung weiterer Abteilungen und Fakultäten denkbar. Dies ist durch die Datenstruktur bereits vorbereitet, jedoch könnte es erforderlich sein, die PDF-Dokumente optisch anders darzustellen. 
Auch wäre eine Anbindung an das #hone denkbar, wie bereits in @verwandteArbeiten beschrieben.
Die Zielgruppe der Studierenden könnte zudem von einer Verbesserung der mobilen Ansichten profitieren.
In der Bearbeitungsansicht könnte statt der derzeitigen HTML-Vorschau das tatsächliche Pdf angezeigt werden. Dies wurde durch die Umstellung auf TypeScript bereits vorbereitet und könnte eine sinnvolle Änderung sein, um zum einen eine genauere Vorschau zu ermöglichen und zum anderen die Code-Qualität zu verbessern, indem Abhängigkeiten verringert werden.