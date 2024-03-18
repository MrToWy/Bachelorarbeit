```prisma
model Module {
  id                   Int                     @id @default(autoincrement())
  name               String
  niveau             String
  abbreviation       String
  description        String
  ...
  degreePrograms     DegreeProgramToModule[]
}
```