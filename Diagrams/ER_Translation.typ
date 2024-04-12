```pintora
erDiagram

  TranslatedText {
    INTEGER Id
    VARCHAR Default
    VARCHAR English
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



Module ||--o{ ModuleTitle : "Title(E1)"
Module ||--o{ ModuleSubtitle : "Subtitle(E2)"
Module ||--o{ ModuleNiveau : "Niveau(E3)"

ModuleTitle ||--o{ TranslatedText : "Translated_Title"
ModuleSubtitle ||--o{ TranslatedText : "Translated_Title"
ModuleNiveau ||--o{ TranslatedText : "Translated_Title"


```