#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *

= Entwurf <entwurf>

== Struktur eines Modulhandbuches <structure>
Die Modulhandbücher der Abteilung Informatik haben für alle drei Studiengänge (BIN, MDI und MIN) dieselbe Struktur. Es gibt eine Aufteilung in Module und Teilmodule. Ein Modul kann dabei 0 bis n verschiedene Teilmodule haben und jedes Teilmodul kann zu 1 bis n Modulen gehören. Teilmodule können Studiengangsübergreifend mit Modulen verknüpft werden. #emph("Beispiel"): Es gibt das Modul "MDI-103 Grundlagen der Informatik" und das Modul "BIN-103 Grundlagen der Informatik". Beide verweisen auf das Teilmodul "BIN-103-01 Grundlagen der Informatik". Somit können Studiengangsübergreifende Module abgebildet werden. In der Regel hat jedoch jedes Modul genau ein Teilmodul und umgekehrt gehört in der Regel jedes Teilmodul zu genau einem Modul.

=== Moduleigenschaften
Das Modul enthält zunächst grundlegende Informationen:

#track("Titel", example: "BIN-100 Mathematik 1")[
  Zusammengesetzt aus einem Kürzel des Studiengangs,  einer eindeutigen Zahl und dem Namen des Moduls.
]

#track("Untertitel", example: "Mathematische Grundlagen der Informatik (BIN-MAT1) oder C/C++ (BIN-PR3)")[
  Ein alternativer, ggf. etwas präziserer Name des Moduls, sowie ein Kürzel. In den aktuell veröffentlichten Handbüchern ist hier oft nur das Kürzel angegeben.
]

#track("Modulniveau")[
  
]

#track("Pflicht / Wahlpflicht")[
  
]

#track("Teilmodule")[
  Auflistung aller Teilmodule
]

#track("Verantwortliche(r)")[
  Name der verantwortlichen Person
]

#track("Credits")[
  Anzahl ECTS
]

#track("Präsenzstunden / Selbststudium")[
  Aufwand des Studiums
]

#track("Studiensemester")[
  Vorgeschlagenes Semester
]

#track("Moduldauer")[
  In der Regel "1 Semester"
]

#track("Voraussetzungen nach Prüfungsordnung")[
  
]

#track("Empfohlene Voraussetzungen")[
  
]

#track("Studien-/ Prüfungsleistungen")[
  
]

#track("Angestrebte Lernergebnisse")[
  
]


=== Teilmoduleigenschaften
Die Teilmodule enthalten zusätzlich weitere Informationen:


#track("Sprache")[
  
]

#track("Zuordnung zu Curricula")[
  
]

#track("Veranstaltungsart, SWS")[
  
]

#track("Empfehlungen zum Selbststudium")[
  
]

#track("Gruppengröße")[
  
]

#track("Inhalt")[
  
]

#track("Anforderungen der Präsenzzeit")[
  
]

#track("Anforderungen des Selbststudiums")[
  
]

#track("Literatur")[
  
]



== Datenbankschema / Klassendiagramm <dbschema>

== Benutzeroberflächen <UI>

=== Usability

/*

Usability / User Experience Definition  \
DIN 9241-210

Benutzungsschnittstelle\
DIN 9241-110

max. 7 Informationen gleichzeitig verarbeiten \
https://lexikon.stangl.eu/2912/chunks
Miller, George A. (1956). The Magical Number 7, Plus or Minus Two: Some Limits on Our Capacity for Processing Information. Psychological Review, 63, pp. 81-97. (Stangl, 2024).

*/


=== Grundgerüst

=== Prototyp