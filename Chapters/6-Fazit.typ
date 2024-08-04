#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *



== Fazit
#todo[Einleitung soll gespielgelt werden]

Im Rahmen dieser Bachelorarbeit sollte der Prozess der Bearbeitung des Modulkataloges verbessert werden. Die hierzu aufgestellten Anforderungen wurden größtenteils erfüllt. Unter den nicht erfüllten Anforderungen befinden sich keine Anforderungen, die die produktive Nutzung der Anwendung verhindern. Zwar wäre es gut, wenn die ausstehenden Arbeiten in Zukunft umgesetzt werden, jedoch kann mit dem bestehenden System bereits der aktuell bestehende Arbeitsablauf ersetzt werden. Das System ermöglicht das Anzeigen von Modulkatalogen im PDF-Format und das Anzeigen von Moduldetails in einer modernen Oberfläche. Außerdem können die Informationen der Module im System bearbeitet werden, wobei das System mithilfe von Dropdowns und Plausibilitätschecks unterstützt. Das resultierende Pdf wird automatisch generiert und den Interessierten zur Verfügung gestellt. Außerdem sind wesentliche Informationen zur Einrichtung und Weiterentwicklung des Systems in einer Dokumentation erfasst.

== Ausblick


Code Qualität bei Erstellen von Modul, Submodul viele Redundanzen

#todo[wo wird System aufrufbar sein? -> Einbindung in HSH Website beschreiben]

#todo[welche Infos aus der Prüfungsordnung fehlen noch]

Für die Zukunft ist es denkbar, dass abgesehen von den bereits erfassten nicht erfüllten Anforderungen weitere Funktionen geplant werden. So könnte die moderne Anzeige von einzelnen Modulen um verschiedene Informationen erweitert werden. Es könnte beispielsweise eine Anbindung an den Stundenplan geben, sodass auf der Modulseite auch angezeigt wird, zu welchen Zeiten und an welchem Ort die Lehrveranstaltungen stattfinden. Auch wäre die Anbindung weiterer Abteilungen und Fakultäten denkbar. Dies ist durch die Datenstruktur bereits vorbereitet, jedoch könnte es erforderlich sein, die PDF-Dokumente optisch anders darzustellen. 
Auch wäre eine Anbindung an das #hone denkbar, wie bereits in @verwandteArbeiten beschrieben.
Die Zielgruppe der Studierenden könnte zudem von einer Verbesserung der mobilen Ansichten profitieren.
In der Bearbeitungsansicht könnte statt der derzeitigen HTML-Vorschau das tatsächliche Pdf angezeigt werden. Dies wurde durch die Umstellung auf TypeScript bereits vorbereitet und könnte eine sinnvolle Änderung sein, um zum einen eine genauere Vorschau zu ermöglichen und zum anderen die Code-Qualität zu verbessern, indem Abhängigkeiten verringert werden.