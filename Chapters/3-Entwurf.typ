#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *
#import "@preview/pintorita:0.1.1"
#show raw.where(lang: "pintora"): it => pintorita.render(it.text)

= Entwurf <entwurf>

== Struktur eines Modulhandbuches <structure>
Die Modulhandbücher der Abteilung Informatik haben für alle drei Studiengänge (BIN, MDI und MIN) dieselbe Struktur. Es gibt eine Aufteilung in Module und Teilmodule. Ein Modul kann dabei 0 bis n verschiedene Teilmodule haben und jedes Teilmodul kann zu 1 bis n Modulen gehören. Teilmodule können Studiengangsübergreifend mit Modulen verknüpft werden. #emph("Beispiel"): Es gibt das Modul "MDI-103 Grundlagen der Informatik" und das Modul "BIN-103 Grundlagen der Informatik". Beide verweisen auf das Teilmodul "BIN-103-01 Grundlagen der Informatik". Somit können Studiengangsübergreifende Module abgebildet werden. In der Regel hat jedoch jedes Modul genau ein Teilmodul und umgekehrt gehört in der Regel jedes Teilmodul zu genau einem Modul.

=== Moduleigenschaften <properties>
Das Modul enthält zunächst grundlegende Informationen:

#track("Titel", example: "BIN-100 Mathematik 1")[
  Zusammengesetzt aus einem Kürzel des Studiengangs,  einer eindeutigen Zahl und dem Namen des Moduls.
]

#track("Untertitel", example: "Mathematische Grundlagen der Informatik (BIN-MAT1) oder C/C++ (BIN-PR3)")[
  Ein alternativer, ggf. etwas präziserer Name des Moduls, sowie ein Kürzel. In den aktuell veröffentlichten Handbüchern ist hier oft nur das Kürzel angegeben.
]

#track("Modulniveau")[
  Hier steht entweder Grundlagenmodul oder Vertiefungsmodul. 
]

#track("Pflicht / Wahlpflicht")[
  Hier steht entweder Pflichtmodul oder Wahlpflichtmodul.
  Studierende müssen alle Pflichtmodule absolvieren und müssen eine bestimmte Anzahl an selbstausgewählten Wahlpflichtmodul absolieren.
]

#track("Teilmodule")[
  Auflistung aller Teilmodule.
]

#track("Verantwortliche(r)", example: "Wohlfeil, Stefan, Prof. Dr.")[
  Name der verantwortlichen Person. Diese Person ist für die Bearbeitung des Modulhandbuches zuständig.
]

#track("Credits")[
  Anzahl erreichbarer ECTS bei Absolvierung dieses Moduls. Eine Zahl zwischen 2 (Englisch) und 30 (z.B. Masterarbeit).
]

#track("Präsenzstunden / Selbststudium", example: "68 h / 112 h")[
  Aufwand des Studiums, aufgeteilt nach der Zeit die in der Hochschule verbracht wird und der Zeit, die im Selbststudium verbracht wird (Arbeit an Übungen, Prüfungsvorbereitung...).
]

#track("Studiensemester")[
  Vorgeschlagenes Semester. Anhand dieser Information wird das Curriculum generiert (@mdiCurr). 
]

#track("Moduldauer")[
  In der Regel "1 Semester".
]

#track("Voraussetzungen nach Prüfungsordnung", example: "Alle Modulprüfungen des 1. bis 3. Semesters")[
  Für die Absolvierung des Moduls zwingend erforderliche Voraussetzungen.
]

#track("Empfohlene Voraussetzungen", example: "Alle Module der Semester 1 bis 3 sowie BIN-112 und BIN-202")[
  Für die Absolvierung des Moduls empfohlene Voraussetzungen.
]

#track("Studien-/ Prüfungsleistungen", example: "Referat (Hausarbeit plus Präsentation/Vortrag), Anwesenheitspflicht")[
  Kommagetrennte Auflistung der zu erbringenden Leistungen.
]

#track("Angestrebte Lernergebnisse", example: "Die Studierenden sind in der Lage, dreidimensionale Objekte zu gestalten, zu bewegen und zueinander in Beziehung zu setzen.", label:<erg>)[
  Eine Stichpunktartige, Kommagetrennte Auflistung der Kompetenzen.
]

#text(" ")<EndOfChapter>

=== Teilmoduleigenschaften
Die Teilmodule enthalten zusätzlich weitere Informationen:

#context [
  #for (value) in (range(counter(heading).at(<EndOfChapter>).last())) {
  counter(heading).step(level: 9)
}
]

#track("Sprache")[
  Hier steht immer entweder "nach Vereinbarung" oder "deutsch".
]

#track("Zuordnung zu Curricula", example: "BIN, MDI")[
  Auflistung aller Studiengänge, in denen dieses Teilmodul verwendet wird.
]

#track("Veranstaltungsart, SWS", example: "Vorlesung mit Übung, 4 SWS")[
  Eine Kurzbeschreibung zum Ablauf der Veranstaltung, sowie deren Dauer in Semesterwochenstunden.
]

#track("Empfehlungen zum Selbststudium", example: "Aufbereitung der Lehrveranstaltung anhand von eigenen Projekten")[
  Hier stehen Vorschläge, wie der Lehrinhalt im Selbststudium vertieft werden kann.
]

#track("Gruppengröße")[
  Üblicherweise eine Zahl zwischen 1 (Bachelorarbeit) und 100 (Mathematik 1).
]

#track("Inhalt", example: "Neue und aktuelle Trends im Bereich Betriebssysteme und Netze")[
  Die Inhalte der Veranstaltung kurz zusammengefasst.
]

#track("Anforderungen der Präsenzzeit", example: "Regelmäßige und aktive Teilnahme.")[
  Hier ist kurz beschrieben, was von Studierenden in der Präsenzzeit erwartet wird.
]

#track("Anforderungen des Selbststudiums", example: "Vor- und Nachbereitung")[
  Hier ist kurz beschrieben, was von Studierenden außerhalb der Präsenzzeit erwartet wird.
]

#track("Literatur", example: "Skript zur Vorlesung
Reges, S., Stepp, M.: Building Java Programs, Prentice Hall")[
  Eine Auflistung empfohlener Literatur zur Vertiefung des behandelten Themas.
]



== Datenbankschema <dbschema>

Um die Datenstruktur zu planen wurde zunächst ein ER-Diagramm erstellt (@ER).
Hierfür wurden im ersten Schritt Tabellen für Module und Teilmodule geplant. Damit das System auch für alle Fakultäten und alle Studiengänge nutzbar ist wurden zusätzlich die Tabellen Faculty und Course geplant.  
Um die Anforderungen @SHOWCHANGES und @REVERT vorzubereiten wurde die Tabelle Changelog genutzt.
Die bestehende User-Tabelle wurden an verschiedenen Stellen referenziert, um beispielsweise die Verantwortlichen Personen anzugeben.
Eigenschaften die aus @requirements oder aus @properties hervorgehen sind dementsprechend markiert.

#diagramFigure("ER-Diagramm - Gesamtbild", <ER>, "ER")


Um die Anforderung @TRANSLATEMULTIPLE vorzubereiten, wurde die Tabelle TranslatedText für alle Eigenschaften mit dem Datentyp "TEXT" genutzt. Zur besseren Lesbarkeit wurde dies nur exemplarisch für die Eigenschaften E1-E3 dargestellt:

#diagramFigure("ER-Diagramm - TranslatedText", <ER_TRANS>, "ER_Translation")



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