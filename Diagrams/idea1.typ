```pintora

erDiagram

  Module {
    INT id PK
    INT credits
    INT hoursPresence
    INT nameId
    INT subTitleId
    INT descriptionId
    INT examId
    INT learningOutcomesId
  }

  Translation {
    INT id PK
    STRING German
    STRING English
    INT languageId FK
  }

  

```