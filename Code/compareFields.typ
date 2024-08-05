```ts
const fields = Object.keys(unchangedObject);

fields.forEach(field => {
  if (Array.isArray(unchangedObject[field])) {
    if (field === "translations") {
      compareTranslations(unchangedObject, newObject, baseFieldName);
    } else {
      compareArrayField(unchangedObject, newObject, baseFieldName, field);
    }
  } else {
    comparePrimitiveField(unchangedObject, newObject, baseFieldName, field);
  }
});
```