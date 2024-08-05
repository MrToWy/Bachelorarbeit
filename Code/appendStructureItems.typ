
#import("../Template/customFunctions.typ"): *

#codly(
highlights:(
  (line:6, fill:green, label: <appendStructureItemsTakeTwoColumns>),
   (line:4, start:26, end:36, label: <getValueCall>)
)
)

```ts
private async appendStructureItems(items: any[], entity: any, languageAbbreviation: string): Promise<string> {
  let latexString = "";
  for (const line of items) {
    const col1 = line.translations[0].name;
    const col2 = await this.getValue(entity, languageAbbreviation, line.paths as PdfStructureItemPathIncludingField[]);

    if (!line.takeTwoColumns) {
      latexString += `\\textbf{${col1}} & ${col2} \\\\ \n`;
    } else {
      latexString += `\\multicolumn{2}{{p{16.5cm}}}{ \\textbf{{${col1}}} \\newline ${col2} } \\\\ \n`;
    }
  }
  return latexString;
}
```