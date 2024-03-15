#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *

= Einleitung <introduction>

== Hintergrund und Motivation
Modulhandbücher begegnen vielen Menschen bereits vor dem Start des Studiums bei der Recherche nach interessanten Studiengängen @ects. In Modulhandbüchern befinden sich die wesentlichen Informationen und Rahmenbedingungen zu den einzelnen Modulen eines Studiengangs. Da sich Lehrinhalte, Zuständigkeiten und auch ganze Studiengänge verändern @hachmeister_im_2016, müssen die Modulhandbücher ebenfalls regelmäßig bearbeitet und bereitgestellt werden. Dieser Aktualisierungsprozess wird vom zuständigen Dekanat der Abteilung Informatik als suboptimal angesehen, weshalb Verbesserungsvorschläge diskutiert werden. Weiterhin befinden sich andere Systeme in der Entwicklung (mehr dazu in @andereAnwendungen), welche von einer korrekten und aktuellen Auflistung aller Module eines Studienganges profitieren. 
In dieser Arbeit soll eine Webanwendung erstellt werden, welche die Bearbeitung und Veröffentlichung von Modulhandbüchern simplifiziert. Der neue Prozess soll eine bessere Usability haben und effizienter sein. Das Ergebnis dieser Arbeit wird ein Prototyp sein, mit dem Modulhandbücher in einer Oberfläche verwaltet, bearbeitet und angezeigt werden können. Die Oberfläche der Webanwendung wird dabei nicht unbedingt ästhetisch ansprechend sein, da der Fokus primär auf der Funktionalität und der Prozessoptimierung liegt.

== Aufbau der Arbeit

== Definition und Zweck eines Modulhandbuchs

§ 7 der Nds. StudAkkVO @studAkkVO beschreibt, dass jeder Studiengang in zeitlich und thematisch abgegrenzte Module einzuteilen ist. Des Weiteren ist eine Beschreibung des Moduls und dessen Merkmale erforderlich. 

#attributedQuote([@modulhandbuecher])[
Ein Modulhandbuch dient der Orientierung im Studium und beschreibt die einzelnen Module eines Studiengangs detailliert.

Das Modulhandbuch spiegelt einerseits die Prüfungsordnung wider, bietet darüber hinaus jedoch umfangreiche inhaltliche Hinweise zu den einzelnen Lehrveranstaltungen […].
]

Es gibt verschiedene Zielgruppen für Modulhandbücher, die in @zielgruppen genauer betrachtet werden. Des Weiteren wird in @structure die Struktur von verschiedenen Modulhandbüchern untersucht und anschließend in @dbschema ein dazu passendes Datenbankschema erstellt.

 

== Ähnliche Arbeiten
Bevor mit der Planung des neuen Systems zur Verwaltung von Modulhandbüchern begonnen wurde, fand zunächst eine Recherche zu ähnlichen Arbeiten statt. Ein System, welches ein ähnliches Problem löst ist der Curriculum Designer im #hone @hisinone der #his @his. Das #hone wird beispielsweise von der Universität Hohenheim zur Verwaltung der Modulhandbücher genutzt @hohenheimHIS. Weiterhin ist das #hone an der #hsh im Einsatz @hshHIS, um dort die Prüfungsanmeldungen zu realisieren.

Webservices zur Anbindung von:
E-Learning-Systemen, Raumplanern, Facility Management-Systemen etc.
https://www.his.de/hisinone


His in One funktioniert nicht mit StudyPlan 