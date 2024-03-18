#import "@preview/gloss-awe:0.0.5": *

    // Defining the Glossary Pool with definitions.
    #let glossary-pool = (
        StudyBase: (
            description: [

                Das gemeinsame Backend von verschiedenen Anwendungen der Abteilung Informatik.

            ]
        ),

        StudyGraph: (
          description: [
            Eine Anwendung, die den Zusammenhang zwischen Studieninhalten, Modulen und Studiengängen in einer Graphenstruktur visualisiert.
          ]
        ),

        StudyPlan: (
          description: [
            Eine Anwendung, mit der Studierende ihr Studium individuell planen können.
          ]
        ),

        Controller: (
          description: [
            Controller sind für die Bearbeitung eingehender Anfragen und die Rückgabe von Antworten an den Client zuständig. @nestDocumentation
          ]
        ),
        
        NestJS: (
          description: [
            Ein auf JavaScript basierendes Framework für serverseitige Anwendungen. @nestDocumentation
          ]
        ),

        Prisma:(
          description: [
            "Automatisch generierter und typsicherer Datenbankabfrage-Generator für Node.js & TypeScript" @prisma
          ]
        )
    )

    