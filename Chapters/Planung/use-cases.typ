#import "../../Template/customFunctions.typ": *


#useCase(1, "Informationen zu Studiengang")[
  Der Use Case beschreibt, wie eine Studieninteressierte Person einen Überblick über alle Module eines Studienganges erhalten kann. Die Person möchte hierzu ein PDF erhalten, in dem alle Module und deren Eigenschaften aufgelistet sind.
][
  Studieninteressierte Person (@studieninteressiertePerson)
][
  Der Studiengang ist im System hinterlegt.
][
  1. Die Person besucht die Website der #hsh
  2. Der gesuchte Studiengang wird aufgerufen
  3. Die Seite des Studiengangs enthält eine Verlinkung zum System StudyModules
  4. Die Person klickt im neuen System auf "PDF anzeigen"
  5. Das System zeigt das PDF an
]<UseCaseInfoDegree>

#useCase(2, "Informationen zu Modul")[
  Der Use Case beschreibt, wie eine studierende Person Informationen zu einem bestimmten Modul erhalten kann. Dabei können die angebotenen Module mithilfe einer Filterfunktion oder Suchfunktion durchsucht werden. Zum Beispiel könnte die studierende Person auf der Suche nach einem spannenden Wahlpflichtfach sein.
][
  Studierende Person (@student)
][
  Der Studiengang ist im System hinterlegt.
][
  1. Die Person besucht die Website der #hsh
  2. Der gesuchte Studiengang wird aufgerufen
  3. Die Seite des Studiengangs enthält eine Verlinkung zum System StudyModules
  4. Im neuen System werden alle Module aufgelistet
  5. Die Person filtert nach allen Wahlpflichtfächern
  6. Die Person öffnet ein Modul
  7. Informationen zum ausgewählten Modul werden in einer modernen Oberfläche angezeigt
]<UseCaseInfoModule>


#useCase(3, "Modul bearbeiten")[
  Der Use Case beschreibt, wie Informationen eines Moduls verändert werden können. Das System prüft dabei, ob die angegebenen Informationen plausibel sind. Beispielsweise müssen Zeitaufwände und ECTS zusammenpassen.
][
  Modulverantwortliche Person (@modulverantwortlicher)
][
  Erfolgreich mit einem Account eingeloggt, der das ausgewählte Modul bearbeiten darf
][
  1. User drückt auf "Bearbeiten"
  2. System wechselt in den Bearbeitungsmodus
  3. User aktualisiert Texte in den Eingabefeldern
  4. User drückt auf "Speichern"
  5. System prüft, ob Änderungen plausibel sind
  6. System wechselt in den Anzeigemodus
]<UseCaseEditModule>



#useCase(4, "Datensatz anlegen")[
  Der Use Case beschreibt, wie ein neuer Datensatz angelegt werden kann. 
  Das System prüft dabei, ob die angegebenen Informationen plausibel sind. Ein Datensatz kann zum Beispiel ein Modul sein, ein Teilmodul oder ein Studiengang. Zur Übersichtlichkeit wurde nicht für jede Art ein einzelner Use Case erstellt.
][
  Studiengangsverantwortliche Person
][
  Erfolgreich mit einem Account eingeloggt, der Datensätze anlegen darf
][
  Am Beispiel eines Modules:
  1. User drückt auf Module
  2. User drückt auf "Hinzufügen"
  3. System wechselt in den Bearbeitungsmodus
  4. User füllt Eingabefelder 
  5. User drückt auf "Speichern"
  6. System prüft, ob Angaben plausibel sind
  7. System zeigt "Modul erfolgreich angelegt"
]<UseCaseCreate>




#useCase(5, "Änderungen rückgängig machen")[
  Der Use Case beschreibt, wie Änderungen an einem Modul rückgängig gemacht werden können. Damit können sowohl eigene Änderungen, als auch die Änderungen anderer User zurückgesetzt werden.
][
  Studiengangsverantwortliche Person
][
  Erfolgreich mit einem Account eingeloggt, der Module bearbeiten darf
][
  1. User öffnet Modul
  2. User drückt auf "Änderungs-Historie"
  3. System zeigt Änderungen
  4. User drückt auf "Änderungen rückgängig machen" 
  5. System zeigt "Änderungen rückgängig gemacht"
]<UCRevertChanges>

#useCase(6, "Prüfungsordnung verifizieren")[
  Der Use Case beschreibt, wie das System bei der Erstellung der Prüfungsordnung unterstützen kann. Die hierzu erforderliche Tabelle kann im System generiert werden, um zu vergleichen, ob alle Daten korrekt hinterlegt sind.
][
  Studiengangsverantwortliche Person
][
  Alle Module des Studiengangs angelegt
][
  1. User erstellt die Tabelle manuell
  2. User öffnet die generierte Tabelle im System
  3. User vergleicht beide Tabellen, um sicherzustellen dass sie korrekt sind
]<UseCaseTable>