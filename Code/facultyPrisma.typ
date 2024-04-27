```prisma
model Faculty {
 id     Int             @id @default(autoincrement())
 name    TranslationKey? @relation(fields: [nameId], references: [id])
 nameId Int?
...
```