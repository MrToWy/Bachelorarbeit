```pintora
erDiagram

  TranslatedText {
    INTEGER Id
    VARCHAR Text
}

  Module {
    INTEGER Id
  }

  ModuleTitle {
    INTEGER Id
}

  ModuleSubtitle {
    INTEGER Id
}

  ModuleNiveau {
    INTEGER Id
}

  Language {
    INTEGER Id
    VARCHAR Name
    VARCHAR ISOCode
}



Module ||--|| ModuleTitle : "Title(E1)"
Module ||--|| ModuleSubtitle : "Subtitle(E2)"
Module }o--|| ModuleNiveau : "Niveau(E3)"

ModuleTitle ||--o{ TranslatedText : "Translated_Title"
ModuleSubtitle ||--o{ TranslatedText : "Translated_Title"
ModuleNiveau ||--o{ TranslatedText : "Translated_Title"
TranslatedText }o--|| Language : "Language"
```