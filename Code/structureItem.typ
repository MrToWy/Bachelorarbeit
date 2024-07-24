#import("../Template/customFunctions.typ"): *

#codly(
highlights:(
  (line:2, fill:green, label: <structureItemTakeTwoColumns>),
  (line:6, fill:red, label: <structureItemPath>),
  (line:13, label: <structureItemSuffix>),
  (line:20, label: <structureItemName>),
)
)



```json
{
  "position": 7,
  "takeTwoColumns": false,
  "paths": [
    {
      "field": {
        "path": "hoursPresence",
        "suffix": " h / "
      }
    },
    {
      "field": {
        "path": "hoursSelf",
        "suffix": " h"
      }
    }
  ],
  "translations": [
    {
      "id": 39,
      "name": "Präsenzstunden / Selbststudium",
      "languageId": 1,
      "pdfStructureItemId": 20
    }
  ]
}

```