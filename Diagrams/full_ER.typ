```pintora
erDiagram

  Faculty {
    INT id PK
    STRING color
  }

  Faculty_Translation {
    INT id PK
    STRING name
    INT languageId FK
    INT facultyId FK
  }

  Department {
    INT id PK
    INT facultyId FK
  }

  Department_Translation {
    INT id PK
    STRING name
    INT languageId FK
    INT departmentId FK
  }

  DegreeProgram {
    INT id PK
    STRING abbreviation
    STRING degree
    INT semesters
    STRING start
    STRING form
    STRING link
    STRING po
    INT departmentId FK
    BOOLEAN locked
    BOOLEAN hidden
  }

  DegreeProgram_Translation {
    INT id PK
    STRING name
    STRING pruefungsordnung
    INT languageId FK
    INT degreeProgramId FK
  }

  ModuleGroup {
    INT id PK
    INT requiredCreditsFromThisGroup
    INT degreeProgramId FK
  }

  ModuleGroup_Translation {
    INT id PK
    STRING name
    INT languageId FK
    INT moduleGroupId FK
  }

  Module {
    INT id PK
    INT number
    STRING abbreviation
    INT credits
    INT hoursPresence
    INT hoursSelf
    STRING semester
    INT courseLength
    BOOLEAN elective
    BOOLEAN specialization
    INT requirementsHardId FK
    INT requirementsSoftId FK
    INT responsibleId FK
    INT degreeProgramId FK
    INT groupId FK
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

  SubModule {
    INT id PK
    INT number
    STRING abbreviation
    INT weeklyHours
    INT groupSize
    INT credits
    INT hoursSelf
    INT hoursPresence
    STRING semester
    INT responsibleId FK
    INT degreeProgramId FK
    INT requirementsSoftId FK
  }

  SubModule_Translation {
    INT id PK
    STRING name
    STRING subtitle
    STRING type
    STRING content
    STRING presenceRequirements
    STRING selfStudyRequirements
    STRING spokenlanguage
    STRING literature
    STRING selfStudyHints
    STRING learningOutcomes
    STRING exam
    STRING semester
    INT languageId FK
    INT subModuleId FK
  }

  User {
    INT id PK
    STRING email
    STRING firstName
    STRING lastName
    STRING password
    INT role
    BOOLEAN canBeResponsible
    INT degreeProgramId
  }

  User_Translation {
    INT id PK
    STRING title
    INT languageId FK
    INT userId FK
  }

  RequirementList {
    INT id PK
    STRING requiredSemesters
    INT degreeProgramId FK
  }

  RequirementList_Translation {
    INT id PK
    STRING name
    INT languageId FK
    INT requirementListId FK
  }

  Changelog {
    INT id PK
    INT userId FK
    STRING description
    DATETIME created
    STRING table
    INT objectId
  }

  ChangelogItem {
    INT id PK
    INT changelogId FK
    STRING field
    STRING oldValue
    STRING newValue
  }

  Job {
    INT id PK
    STRING sourceFilePath
    STRING resultFilePath
    STRING guid
    INT degreeProgramId FK
    INT languageId FK
    DATETIME startedAt
    DATETIME finishedAt
    DATETIME errorAt
    DATETIME publishedAt
  }

  PdfStructure {
    INT id PK
    INT degreeProgramId FK
  }

  PdfStructureTranslation {
    INT id PK
    STRING date
    STRING page
    STRING of
    STRING faculty
    STRING handbook
    STRING poVersion
    INT languageId FK
    INT pdfStructureId FK
  }

  PdfStructureItem {
    INT id PK
    INT pdfStructureId FK
    INT position
    BOOLEAN takeTwoColumns
    BOOLEAN moduleBased
    BOOLEAN subModuleBased
  }

  PdfStructureItemPath {
    INT id PK
    INT pdfStructureItemId FK
    INT fieldId FK
    INT position
  }

  PdfStructureItemField {
    INT id PK
    STRING path
    STRING suffix
    BOOLEAN moduleBased
    BOOLEAN subModuleBased
  }

  PdfStructureItemTranslation {
    INT id PK
    STRING name
    INT languageId FK
    INT pdfStructureItemId FK
  }

  Language {
    INT id PK
    STRING abbreviation
  }

  User ||--o{ User_Translation : "translations"
  
  
  Module }o--|| DegreeProgram : "degreeProgram"
  Module }o--o{ SubModule : "subModules"
  Module ||--o{ Module_Translation : "translations"
  Module }o--|| ModuleGroup : "group"
  Module ||--|| RequirementList : "requirementsSoft&Hard                "
  Module }o--o| User : "responsible"
  RequirementList }o--o{ Module : "modules"
  SubModule }o--|| DegreeProgram : "degreeProgram"
  SubModule }o--o| User : "responsible"
  SubModule ||--o{ SubModule_Translation : "translations"
  SubModule ||--|| RequirementList : "requirementsSoft"
  
  DegreeProgram }o--|| Department : "department"
  DegreeProgram ||--o{ DegreeProgram_Translation : "translations"
  DegreeProgram ||--o{ Job : "Job"
  DegreeProgram }o--|| PdfStructure : "PdfStructure"  
  
  DegreeProgram |o--o| User : "responsible"
  ModuleGroup ||--o{ ModuleGroup_Translation : "translations"
  Faculty ||--o{ Faculty_Translation : "translations"
  Department }o--|| Faculty : "faculty"
  Department ||--o{ Department_Translation : "translations"
  
  RequirementList ||--o{ RequirementList_Translation : "translations"
  
  Changelog }o--|| User : "user"
  Changelog ||--o{ ChangelogItem : "items"  
  PdfStructure ||--o{ PdfStructureTranslation : "translations"
  PdfStructureItem }o--|| PdfStructure : "pdfStructure"
  PdfStructureItem ||--o{ PdfStructureItemTranslation : "translations"
  PdfStructureItem ||--|{ PdfStructureItemPath : "paths"
  
  PdfStructureItemPath }o--|| PdfStructureItemField : "PdfStructureItemPath"
  Faculty_Translation }o--|| Language : "language"
  Department_Translation }o--|| Language : "language"
  DegreeProgram_Translation }o--|| Language : "language"
  ModuleGroup_Translation }o--|| Language : "language"
  Module_Translation }o--|| Language : "language"
  SubModule_Translation }o--|| Language : "language"
  User_Translation }o--|| Language : "language"
  RequirementList_Translation }o--|| Language : "language"
  PdfStructureTranslation }o--|| Language : "language"
  PdfStructureItemTranslation }o--|| Language : "language"
  Job }o--|| Language : "language"
```