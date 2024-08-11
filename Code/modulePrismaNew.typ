#import("../Template/customFunctions.typ"): *



#text(size: 9.5pt)[
  ```prisma
model Module {
 id Int @id @default(autoincrement())
 name                String?
 degreeProgram       DegreeProgram @relation(fields: [degreeProgramId], references: [id])
 degreeProgramId     Int
...

model DegreeProgram {
  id                 Int           @id @default(autoincrement())
  modules            Module[]
...
```
]
