#import "../../Template/customFunctions.typ": *

#useCase(1, "Suchfunktion")[
  Der Use Case beschreibt, wie Informationen zu einem Studiengang gefunden werden können. Durch die Nutzung einer Autovervollständigung soll ein Studiengang leicht findbar sein.
][
  Studieninteressierte Person
][
  Keine
][
  1. User gibt "MDI" in das Suchfeld ein
  2. System zeigt den Studiengang Mediendesigninformatik an
  3. User klickt den Eintrag an
  4. System zeigt den Studiengang und dessen Module
  5. User klickt auf "PDF anzeigen" und sieht alle Modulbeschreibungen in einem PDF
]<UseCaseSearch>

#useCase(2, "Filterfunktion")[
  Der Use Case beschreibt, wie Informationen zu einem Modul gefunden werden können. Durch die Nutzung verschiedener Filter, soll ein Modul leicht findbar sein.
][
  Studierende Person
][
  Studiengang ausgewählt
][
  1. User wählt in den Filteroptionen als Semester 2 aus
  2. System zeigt alle Module an, die laut Curriculum im 2. Semester empfohlen werden
  3. User klickt einen Eintrag an
  4. System zeigt das Modul
]<UseCaseFilter>


#useCase(3, "Modul bearbeiten")[
  Der Use Case beschreibt, wie Informationen eines Moduls verändert werden können. Das System prüft dabei, ob die angegebenen Informationen plausibel sind. Beispielsweise müssen Zeitaufwände und ECTS zusammenpassen.
][
  Modulverantwortliche Person
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


#useCase(4, "User anlegen")[
  Der Use Case beschreibt, wie ein neuer Benutzeraccount angelegt werden kann. Das System prüft dabei, ob die angegebenen Informationen plausibel sind. Beispielsweise müssen Name und Email Adresse zusammenpassen. Außerdem wird sichergestellt, dass das Passwort sicher ist.
][
  Studiengangsverantwortliche Person
][
  Erfolgreich mit einem Account eingeloggt, der Modulverantwortliche Personen anlegen darf
][
  1. User drückt auf Accountübersicht
  2. User drückt auf "Hinzufügen"
  3. System wechselt in den Bearbeitungsmodus
  4. User füllt Eingabefelder 
  5. User drückt auf "Speichern"
  6. System prüft, ob Angaben plausibel sind
  7. System zeigt "Account erfolgreich angelegt"
]<UseCaseCreateUser>


#useCase(5, "Modul anlegen")[
  Der Use Case beschreibt, wie ein neues Modul angelegt werden kann. 
  Das System prüft dabei, ob die angegebenen Informationen plausibel sind.
][
  Studiengangsverantwortliche Person
][
  Erfolgreich mit einem Account eingeloggt, der Module anlegen darf
][
  1. User drückt auf Module
  2. User drückt auf "Hinzufügen"
  3. System wechselt in den Bearbeitungsmodus
  4. User füllt Eingabefelder 
  5. User drückt auf "Speichern"
  6. System prüft, ob Angaben plausibel sind
  7. System zeigt "Modul erfolgreich angelegt"
]<UseCaseCreateModule>

#useCase(6, "Änderungen rückgängig machen")[
  Der Use-Case beschreibt, wie Änderungen an einem Modul rückgängig gemacht werden können. Damit können sowohl eigene Änderungen, als auch die Änderungen anderer User zurückgesetzt werden.
][
  Studiengangsverantwortliche Person
][
  Erfolgreich mit einem Account eingeloggt, der Module bearbeiten darf
][
  1. User öffnet Modul
  2. User drückt auf "Änderungs-Historie"
  3. System zeigt Änderungen
  4. User drückt auf "Auf diesen Stand zurücksetzen" 
  5. System zeigt "Änderungen rückgängig gemacht"
]<UCRevertChanges>

#useCase(7, "Prüfungsordnung verifizieren")[
  Der Use-Case beschreibt, wie das System bei der Erstellung der Prüfungsordnung unterstützen kann. Die hierzu erforderliche Tabelle kann im System generiert werden, um zu vergleichen, ob alle Daten korrekt hinterlegt sind.
][
  Studiengangsverantwortliche Person
][
  Alle Module des Studiengangs angelegt
][
  1. User erstellt die Tabelle manuell
  2. User öffnet die generierte Tabelle im System
  3. User vergleicht beide Tabellen, um sicherzustellen dass sie korrekt sind
]<UseCaseTable>