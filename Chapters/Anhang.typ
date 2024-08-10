#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *

#heading(numbering: none)[Anhang]

#heading(numbering: none, level: 2)[Quellcode]
Der in dieser Arbeit entstandene Quellcode ist an den folgenden Stellen zu finden.

#heading(numbering: none, level: 3, outlined: false)[Frontend & Entwicklerdokumentation]


https://github.com/MrToWy/StudyModules-Frontend/

Branch: `master`

Commit-Hash: `6c9cf1bbf415f23d6f791c1e88b90401ccff6880`

#heading(numbering: none, level: 3, outlined: false)[Backend & LaTeX-Skript]

https://gitlab.gwdg.de/lernanwendungen/studybase

Branch: `studymodules_tobi`

Commit-Hash: `0ffad0bc580e4641205aa0cf3011480f5875c706`

#pagebreak()

#heading(numbering:none, level: 2)[Interview-Fragen]<interviewFragen>

*Häufigkeit von Änderungen* 
_Falls diese Informationen nicht vorliegen - ist ein geeigneter Ansprechpartner an der Hochschule bekannt?_

1. Wie häufig ändern sich einzelne Details zu einem Modul? Details sind z.B. Verantwortliche(r), Angestrebte Lernergebnisse, Gruppengröße...
	- welche Details ändern sich am häufigsten? 


2. Wie häufig gibt es neue Module / Wie häufig werden alte Module entfernt?


3.  Wie häufig gibt es neue Studiengänge / Wie häufig werden alte Studiengänge entfernt 



* Design*

4. muss neues Modulhandbuch 1zu1 so aussehen wie altes Modulhandbuch? Oder darf ein neues Design verwendet werden, wenn trotzdem alle Informationen übersichtlich erkennbar sind 


*Workflow*

5. Wenn es Änderungen am Inhalt eines Modulhandbuches gibt, was passiert dann genau?  



5.2 Wer ist für welche Aufgabe zuständig?



6. Werden die englischen Handbücher nach dem selben Prinzip manuell erstellt, oder passiert das automatisch?  


7. Welche Schwierigkeiten & Probleme haben Sie mit dem aktuellen Prozess?


*Ideen*

8. Haben Sie Vorstellungen / Anforderungen / Ideen für das neue System?

#pagebreak()


#heading(numbering: none, level: 2)[Größere Codebeispiele]


#codeFigure("Backend: Erstellen und Bearbeiten von Modulen", <endpointBefore>, "endpointBefore")

#codeFigure("Backend: Erstellen und Bearbeiten von Modulen (Verbessert)", <endpointAfter>, "endpointAfter")

#codeFigure("Vergleichsmethoden", <compareFields2>, "compareFields2")

#codeFigure("Beispiel eines StructureItems", <structureItem>, "structureItem")

#codeFigure("getValue-Methoden", <getValueMethods>, "getValue")






#heading(numbering: none, level: 2)[Screenshots der Webanwendung]





#imageFigure(<filterResult>, "../Images/filter.png", "Filtermöglichkeit")





#imageFigure(<hiddenCourse>, "../Images/HiddenCourse.png", "Ausgelendeter Studiengang")

#imageFigure(<errorMsg>, "../Images/errormsg.png", "Fehlermeldung vom error.service.ts")

#imageFigure(<changelog>, "../Images/Changelog.png", "Änderungshistorie")