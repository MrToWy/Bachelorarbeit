#text(size: 8.5pt)[
  ```prisma
model Module {
 id Int @id @default(autoincrement())
 name TranslationKey? @relation(name: "name", fields: [nameId], references: [id])
 nameId    Int?
 description TranslationKey? @relation(name: "description", fields: [descriptionId], references: [id])
 descriptionId Int?
...

model TranslationKey {
  id                 Int           @id @default(autoincrement())
  translations       Translation[]
  facultyNames       Faculty[]
  moduleNames        Module[]      @relation("name")
  moduleDescriptions Module[]      @relation("description")
...
```
]
