#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *



= Fazit
Im Rahmen dieser Bachelorarbeit sollte der Prozess der Bearbeitung des Modulkataloges verbessert werden. Die hierzu aufgestellten Anforderungen wurden größtenteils erfüllt. Unter den nicht erfüllten Anforderungen befinden sich keine Anforderungen, die die produktive Nutzung der Anwendung verhindern. Zwar wäre es gut, wenn die ausstehenden Arbeiten in Zukunft umgesetzt werden, jedoch kann mit dem bestehenden System bereits der aktuell bestehende Arbeitsablauf ersetzt werden. Das System ermöglicht das Anzeigen von Modulkatalogen im PDF-Format und das Anzeigen von Moduldetails in einer modernen Oberfläche. Außerdem können die Informationen der Module im System bearbeitet werden, wobei das System mithilfe von Dropdowns und Plausibilitätschecks unterstützt. Das resultierende Pdf wird automatisch generiert und den Interessierten zur Verfügung gestellt. Außerdem sind wesentliche Informationen zur Einrichtung und Weiterentwicklung des Systems in einer Dokumentation erfasst.

Durch die modernen Oberflächen sollte es Studierenden und Studieninteressierten Personen leicht fallen, an die gewünschten Informationen zu bestimmten Modulen oder einem Studiengang zu gelangen. Für die Dozierenden Personen an der #hsh sollte die Aktualisierung der Modultexte dank der intuitiven Eingabefelder sowie der unterstützenden Plausibilitätsprüfung angenehmer sein. Die Generierung eines Pdfs läuft jetzt weitestgehend automatisch, sodass der Studiengangsdekan für diese Aufgabe nun weniger Zeit benötigen sollte.



= Ausblick
Der nächste Schritt für das neue System könnte die Einführung sein. Hierzu müssten die Modulverantwortlichen zunächst einmal das generierte Pdf, beziehungsweise die im System hinterlegten Daten, auf Vollständigkeit prüfen. Im Anschluss könnte das System auf Hochschulservern eingerichtet werden. Ein Link zu verschiedenen Seiten des Systems könnte dann auf der Website der Hochschule erstellt werden. Es wäre beispielsweise denkbar, auf der Unterseite der Abteilung Informatik auf die Studiengangsübersicht des neuen Systems (@menu) zu verlinken.


Für die nähere Zukunft ist es außerdem denkbar, dass abgesehen von den bereits erfassten nicht erfüllten Anforderungen weitere Funktionen geplant werden. So könnte die moderne Anzeige von einzelnen Modulen um verschiedene Informationen erweitert werden. Es könnte beispielsweise eine Anbindung an den Stundenplan geben, sodass auf der Modulseite auch angezeigt wird, zu welchen Zeiten und an welchem Ort die Lehrveranstaltungen stattfinden. Auch wäre die Anbindung weiterer Abteilungen und Fakultäten denkbar. Dies ist durch die Datenstruktur bereits vorbereitet, jedoch könnte es erforderlich sein, die PDF-Dokumente optisch anders darzustellen. 
Auch wäre eine Anbindung an das #hone denkbar, wie bereits in @verwandteArbeiten beschrieben.

In der Bearbeitungsansicht könnte statt der derzeitigen HTML-Vorschau das tatsächliche Pdf angezeigt werden. Dies wurde durch die Umstellung auf TypeScript bereits vorbereitet und könnte eine sinnvolle Änderung sein, um zum einen eine genauere Vorschau zu ermöglichen und zum anderen die Code-Qualität zu verbessern, indem Abhängigkeiten verringert werden.




Das neu entworfene System könnte zudem Vorlage für weitere Entwicklungen sein. Die genutzten Technologien, sowie die entworfene Struktur könnte für eine Vielzahl von Projekten interessant sein.