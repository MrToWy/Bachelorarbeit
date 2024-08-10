#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *



= Fazit<fazit>
Das in @introduction aufgestellte Ziel, eine Webanwendung zu erstellen, welche die Bearbeitung und Veröffentlichung von Modulhandbüchern erleichtert, wurde durch eine klare Struktur angegangen. Nachdem in @anforderungsanalyse die Zielgruppen und Anforderungen ermittelt wurden, konnte in @entwurf das System geplant werden. In @implementierung wurden die Anforderungen umgesetzt, was in @review bestätigt wurde.

Das Ergebnis dieser Bachelorarbeit ist ein verbesserter Prozess zur Bearbeitung des Modulkataloges. Die hierzu aufgestellten Anforderungen wurden größtenteils erfüllt. Unter den nicht erfüllten Anforderungen befinden sich keine Anforderungen, die die produktive Nutzung der Anwendung verhindern. Zwar wäre es gut, wenn die ausstehenden Arbeiten in Zukunft umgesetzt werden, jedoch kann mit dem bestehenden System bereits der aktuell bestehende Arbeitsablauf ersetzt werden. Das System ermöglicht das Anzeigen von Modulkatalogen als PDF und das Anzeigen von Moduldetails in einer modernen Oberfläche. Außerdem können die Informationen der Module im System bearbeitet werden, wobei das System mithilfe von Dropdowns und Plausibilitätschecks unterstützt. Das resultierende PDF wird automatisch generiert und den Interessierten zur Verfügung gestellt. Außerdem sind wesentliche Informationen zur Einrichtung und Weiterentwicklung des Systems in einer Dokumentation erfasst.

Durch die modernen Oberflächen sollte es Studierenden und studieninteressierten Personen leicht fallen, an die gewünschten Informationen zu bestimmten Modulen oder einem Studiengang zu gelangen. Für die dozierenden Personen an der #hsh sollte die Aktualisierung der Modultexte dank der intuitiven Eingabefelder sowie der unterstützenden Plausibilitätsprüfung angenehmer sein. Die Generierung eines PDFs läuft jetzt weitestgehend automatisch, sodass der Studiengangsdekan für diese Aufgabe nun weniger Zeit benötigen sollte.

Alles in allem wurde durch die Erfüllung der wesentlichen Anforderungen und durch die Bereitstellung des neuen Systems das aufgestellte Ziel erreicht. Es gibt eine Webanwendung, die die Verwaltung und Erstellung von Modulhandbüchern ermöglicht.



= Ausblick<ausblick>
Obwohl das neue System bereits funktionsfähig ist, gibt es dennoch Potenzial für weitere Optimierungen. Sowohl die erstellte Dokumentation als auch der Quellcode könnten in bestimmten Bereichen weiter verbessert werden. Einzelne Abschnitte im Code könnten noch redundanten Code enthalten und die Dokumentation enthält nicht alle in dieser Arbeit genannten Einzelheiten des Systems. Sollten bei der Weiterentwicklung verbesserungswürdige Stellen in Dokumentation oder Quellcode auffallen, können diese dokumentiert und verbessert werden. Die aktuelle Struktur des Systems sollte Erweiterungen und Anpassungen ermöglichen.


Der nächste Schritt könnte die Einführung des neuen Systems für die Abteilung Informatik sein. Hierzu könnte das System auf Hochschulservern eingerichtet werden. Im Anschluss müssten die Modulverantwortlichen zunächst einmal das generierte PDF, beziehungsweise die im System hinterlegten Daten, auf Vollständigkeit prüfen. Ein Link zu verschiedenen Seiten des Systems könnte dann auf der Website der Hochschule erstellt werden. Es wäre beispielsweise denkbar, auf der Unterseite der Abteilung Informatik auf die Studiengangübersicht des neuen Systems (@menu) zu verlinken.


Für die nähere Zukunft ist es außerdem denkbar, dass abgesehen von den bereits erfassten nicht erfüllten Anforderungen weitere Funktionen geplant werden. So könnte die moderne Anzeige von einzelnen Modulen um verschiedene Informationen erweitert werden. Es könnte beispielsweise eine Anbindung an den Stundenplan geben, sodass auf der Modulseite auch angezeigt wird, zu welchen Zeiten und an welchem Ort die Lehrveranstaltungen stattfinden. Auch wäre die Anbindung weiterer Abteilungen und Fakultäten denkbar. Dies ist durch die Datenstruktur bereits vorbereitet, jedoch könnte es erforderlich sein, die PDF-Dokumente optisch anders darzustellen. 
Auch wäre eine Anbindung an das #hone denkbar, wie bereits in @verwandteArbeiten beschrieben. 
Zusätzlich zu den Modulhandbüchern und des Anhangs der Prüfungsordnung könnte ebenso die in @definition genannte Abbildung des Curriculums (@mdiCurr) generiert und im neuen System angezeigt werden.

In der Bearbeitungsansicht könnte statt der derzeitigen HTML-Vorschau das tatsächliche PDF angezeigt werden. Dies wurde durch die Umstellung auf TypeScript bereits vorbereitet und könnte eine sinnvolle Änderung sein, um zum einen eine genauere Vorschau zu ermöglichen und zum anderen die Code-Qualität zu verbessern, indem Abhängigkeiten verringert werden.


Das neu entworfene System könnte zudem Vorlage für weitere Entwicklungen sein. Die genutzten Technologien, sowie die entworfene Struktur könnte für eine Vielzahl von Projekten interessant sein.