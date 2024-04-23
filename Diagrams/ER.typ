```pintora
erDiagram

  Faculty {
    INTEGER Id
    TEXT Title
}

  Course {
    INTEGER Id
    TEXT Title
    VARCHAR Shortcut(E1)
}

  Module {
    INTEGER Id
    INTEGER Number(E1)
    TEXT Title(E1)
    TEXT Subtitle(E2)
    VARCHAR Shortcut(E2)
    TEXT Niveau(E3)
    TEXT Type(E4)
    INTEGER Credits(E7)
    INTEGER HoursAtLocation(E8)
    INTEGER HoursAtHome(E8)
    INTEGER Semester(E9)
    INTEGER CourseLength(E10)
    TEXT Exam(E13)
    TEXT Learnings(E14)
  }


  SubModule {
    INTEGER Id
    INTEGER Number(E15)
    TEXT Language(E16)
    TEXT Type(E18)
    INTEGER PresenceHoursPerWeek(E18)
    TEXT LearningRecommendations(E19)
    INTEGER GroupSize(20)
    TEXT Content(E21)
    TEXT PresenceRequirements(E22)
    TEXT LearningRequirements(E23)
    TEXT Literature(E24)
}

  User {
    INTEGER Id
    TEXT Title
    VARCHAR Username
    VARCHAR FirstName
    VARCHAR LastName
    VARCHAR Email
    VARCHAR Password
}

Changelog {
    INTEGER Id
    DATETIME Timestamp
    VARCHAR Table
}

ChangelogItem {
    INTEGER Id
    VARCHAR Column
    VARCHAR PreviousValue
}

RequirementList {
  INTEGER Id
  TEXT Name
  BOOLEAN Optional
}

RequirementListItem {
  INTEGER Id
}

Faculty ||--o{ Course : "Courses"

Course ||--o{ Module : "Modules(E17)"

Module }o--o{ SubModule : "Submodules(E5)"


Module }o--|| User : "Responsible(E6)"
Course }o--|| User : "Responsible"

Changelog }o--|| User : "Author(F15)"
Changelog ||--o{ ChangelogItem : "Changes(F16)"

Module }o--|| RequirementList : "Requirement(E11/12)"
RequirementList }o--o{ RequirementListItem : "Requirements"
Module ||--o{ RequirementListItem : "Module"
```