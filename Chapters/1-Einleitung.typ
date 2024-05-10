#import "../Template/customFunctions.typ": *

= Einleitung <introduction>

== Hintergrund und Motivation <motivation>
Modulhandbücher begegnen vielen Menschen bereits vor dem Start des Studiums bei der Recherche nach interessanten Studiengängen @ects. In Modulhandbüchern befinden sich die wesentlichen Informationen und Rahmenbedingungen zu den einzelnen Modulen eines Studiengangs. Da sich Lehrinhalte, Zuständigkeiten und auch ganze Studiengänge verändern @hachmeister_im_2016, müssen die Modulhandbücher ebenfalls regelmäßig bearbeitet und bereitgestellt werden. Dieser Aktualisierungsprozess wird vom zuständigen Dekanat der Abteilung Informatik als suboptimal angesehen, weshalb Verbesserungsvorschläge diskutiert werden. Weiterhin befinden sich andere Systeme in der Entwicklung (mehr dazu in @andereAnwendungen), welche von einer korrekten und aktuellen Auflistung aller Module eines Studienganges profitieren. 
In dieser Arbeit soll eine Webanwendung erstellt werden, welche die Bearbeitung und Veröffentlichung von Modulhandbüchern simplifiziert. Der neue Prozess soll eine bessere Usability haben und effizienter sein. Das Ergebnis dieser Arbeit wird ein Prototyp sein, mit dem Modulhandbücher in einer Oberfläche verwaltet, bearbeitet und angezeigt werden können. Die Oberfläche der Webanwendung wird dabei nicht unbedingt ästhetisch ansprechend sein, da der Fokus primär auf der Funktionalität und der Prozessoptimierung liegt.



== Definition und Zweck eines Modulhandbuchs

§ 7 der Niedersächsischen Studienakkreditierungsverordnung @studAkkVO beschreibt, dass jeder Studiengang in zeitlich und thematisch abgegrenzte Module einzuteilen ist. Des Weiteren ist eine Beschreibung des Moduls und dessen Merkmale erforderlich. 
Die Aufgabe eines Modulhandbuches ist es, die Orientierung im Studium zu erleichtern und die Prüfungsordnung abzubilden. Das Handbuch soll über die einzelnen Lehrveranstaltungen informieren und diese detailliert beschreiben. @modulhandbuecher


Es gibt noch weitere Dokumente, die Informationen über die Module eines Studienganges enthalten. In @mdiCurr ist das vorgeschlagene Curriculum des Studiengangs Mediendesigninformatik zu sehen. Hier entspricht eine Spalte einem Semester. Die Höhe der Module spiegelt die Anzahl der zu erreichenden Credits wider. 
#imageFigure(<mdiCurr>, "MDI_Curriculum.png")[Curriculum Mediendesigninformatik @fak4]

#box()[
Im Anhang des besonderen Teils der Prüfungsordnung @btpo befindet sich eine Auflistung aller Module des Studiengangs in tabellarischer Form (@currTable).

#imageFigure(<currTable>, "currTable.png")[Auszug Anhang Prüfungsordnung @btpo]
]

Es gibt verschiedene Zielgruppen für Modulhandbücher, die in @zielgruppen genauer betrachtet werden. Des Weiteren wird in @structure die Struktur von verschiedenen Modulhandbüchern untersucht und anschließend in @dbschema ein dazu passendes Datenbankschema erstellt.

 

== Ähnliche Arbeiten
Bevor mit der Planung des neuen Systems zur Verwaltung von Modulhandbüchern begonnen wurde, fand zunächst eine Recherche zu ähnlichen Arbeiten statt. Ein System, welches ein ähnliches Problem löst, ist der "Curriculum Designer" im #hone @hisinone der #his @his. Das #hone wird beispielsweise von der Universität Hohenheim zur Verwaltung der Modulhandbücher genutzt @hohenheimHIS. Weiterhin ist das #hone an der #hsh im Einsatz @hshHIS, um dort die Prüfungsanmeldungen zu realisieren. 


Da es keine öffentlichen Dokumentationen für die Nutzung der Schnittstellen vom #hone gibt und derzeit auch unklar ist, ob das #hone hochschulweit zur Verwaltung von Modulhandbüchern eingesetzt werden soll, bietet es sich an ein eigenes System zu entwickeln. Das selbst entwickelte System hat den zusätzlichen Vorteil, dass es an alle besonderen Anforderungen angepasst werden kann, ohne einen Antrag bei der #his stellen zu müssen.
Sollte die #hsh entscheiden, das #hone in Zukunft auch für die Verwaltung von Modulhandbüchern zu nutzen, könnten die Informationen der Handbücher über Webservices vom #hone und über die REST-Schnittstellen des neuen Systems synchronisiert werden.  


== Aufbau der Arbeit
In dieser Arbeit werden zunächst in @anforderungsanalyse die Anforderungen an das neue System ermittelt. Dafür wird der aktuelle Prozess analysiert, auf Schwachstellen geprüft und es werden die Zielgruppen ermittelt. Anschließend werden Use-Cases, sowie ein zukünftiger Arbeitsprozess entwickelt. Da es bereits Anwendungen gibt, die mit dem neuen System kommunizieren sollen, werden die Anwendungen und deren Struktur untersucht. Abschließend wird eine Liste der Anforderungen erstellt.

In @entwurf werden die Strukturen verschiedener Modulhandbücher untersucht und verglichen. Aus den Ergebnissen der Untersuchung soll dann ein Datenbankschema erstellt werden. Außerdem werden Entwürfe für die Benutzeroberflächen erstellt.

In @implementierung wird zu dem zuvor erstellten Datenbankschema ein Backend erstellt. Anschließend werden aus den zuvor erstellten Entwürfen die Benutzeroberflächen angefertigt. 

Im letzten Kapitel, @review, werden die Ergebnisse überprüft. Dazu wird ein Interview geführt und es werden die Anforderungen auf Erfüllung geprüft. Im Ausblick werden Ideen für zukünftige Erweiterungen diskutiert.