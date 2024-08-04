```pintora
erDiagram

  Module {
    INT id PK
    INT credits
    INT hoursPresence
  }

  Module_Translation {
    INT id PK
    STRING name
    STRING subtitle
    STRING description
    STRING exam
    STRING learningOutcomes
    INT languageId FK
    INT moduleId FK
  }

  Module ||--o{ Module_Translation : "translations"
  
  ```