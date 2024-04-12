```pintora
erDiagram

  Faculty {
    INTEGER Id
    TEXT Title
}

  Course {
    INTEGER Id
    TEXT Title
    VARCHAR Shortcut
}

  Module {
    INTEGER Id
    TEXT Title(E1)
    TEXT Subtitle(E2)
    TEXT Niveau(E3)
    TEXT Type(E4)
    TEXT Submodules(E5)
    TEXT Responsible(E6)
    INTEGER Credits(E7)
    INTEGER HoursAtLocation(E8)
    INTEGER HoursAtHome(E8)
    INTEGER Semester(E9)
    INTEGER CourseLength(E10)
    TEXT Requirement(E11)
    TEXT AdditionalRequirements(E12)
    TEXT Exam(E13)
    TEXT Learnings(E14)
  }


  SubModule {
    INTEGER Id
    TEXT Language(E15)
    TEXT Type(E17)
    INTEGER PresenceHoursPerWeek(E17)
    TEXT LearningRecommendations(E18)
    INTEGER GroupSize(E19)
    TEXT Content(E20)
    TEXT PresenceRequirements(E21)
    TEXT LearningRequirements(E22)
    TEXT Literature(E23)
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

Faculty ||--o{ Course : "Courses"

Course ||--o{ Module : "Modules(E16)"

Module ||--o{ SubModule : "Submodules(E5)"


Module ||--o{ User : "Responsible(E6)"
Course ||--o{ User : "Responsible"

Changelog ||--o{ User : "Author(F15)"
Changelog ||--o{ ChangelogItem : "Changes(F16)"
```