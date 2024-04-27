```prisma
model TranslationKey {
  id           Int           @id @default(autoincrement())
  translations Translation[]
  faculties    Faculty[]
}
```