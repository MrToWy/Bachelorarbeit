```pintora
erDiagram

  User ||--o{ User_Translation : "translations"
  
  
  Module }o--|| DegreeProgram : "degreeProgram"
  Module }o--o{ SubModule : "subModules"
  Module ||--o{ Module_Translation : "translations"
  Module }o--|| ModuleGroup : "group"
  Module }o--o| User : "responsible"
  SubModule }o--|| DegreeProgram : "degreeProgram"
  SubModule }o--o| User : "responsible"
  SubModule ||--o{ SubModule_Translation : "translations"
  
  DegreeProgram ||--o{ DegreeProgram_Translation : "translations"
  
  DegreeProgram |o--o| User : "responsible"
  ModuleGroup ||--o{ ModuleGroup_Translation : "translations"
  

```