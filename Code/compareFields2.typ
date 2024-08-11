#import("../Template/customFunctions.typ"): *

#codly(annotations:(
   (
    start: 12,
    end: 26,
    label: <compareArrayField>
  ),
   (
    start: 28,
    end: 37,
    label: <comparePrimitiveField>
  ),
),
highlights:(
  (line:2, label: <compareTranslations>),
)
)


```ts
const compareTranslations = (unchangedObject: any, newObject: any, baseFieldName: string) => {
  unchangedObject.translations.forEach((oldTranslationObject: any, index: any) => {
    const newTranslationObject = newObject.translations.find((newTranslation: any) => newTranslation.languageId === oldTranslationObject.languageId);
    const languageAbbreviation = languages.find(l => l.id === oldTranslationObject.languageId)?.abbreviation;

    if (newTranslationObject && languageAbbreviation) {
      compareTranslationFields(oldTranslationObject, newTranslationObject, baseFieldName, languageAbbreviation);
    }
  });
};
...

const compareArrayField = (unchangedObject: any, newObject: any, baseFieldName: string, field: string) => {
  const unchangedObjectIds = unchangedObject[field].map((obj: any) => obj.id);
  const newObjectIds = newObject[field].map((obj: any) => obj.id);

  // Check if the arrays contain the same elements, ignore the order
  if (JSON.stringify(unchangedObjectIds.sort()) !== JSON.stringify(newObjectIds.sort())) {
    changes.push({
      field: `${baseFieldName}.${String(field)}`,
      oldValue: unchangedObjectIds,
      newValue: newObjectIds
    });
  }
};



const comparePrimitiveField = (unchangedObject: any, newObject: any, baseFieldName: string, field: string) => {
  if (unchangedObject[field] !== newObject[field]) {
    changes.push({
      field: `${baseFieldName}.${String(field)}`,
      oldValue: unchangedObject[field],
      newValue: newObject[field]
    });
  }
};
```