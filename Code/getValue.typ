#import("../Template/customFunctions.typ"): *

#codly(
highlights:(
  (line:13, label: <getValueFromPath>),
  (line:22, label: <getNestedProperty>),
  (line:26, fill:green, label: <reduce>),
  (line:28, fill:red, label: <detectArray>),
  (line:32, fill:blue, label: <ignoreVar>),
)
)


```ts
private async getValue(module: any, lang: string, paths: PdfStructureItemPathIncludingField[]): Promise<string> {
  let result = "";

  for (const path of paths) {
    result += await this.getValueFromPath(module, lang, path.field.path ?? "") + " " + path.field.suffix;
  }

  return this.formatForLatex(result, lang);
}

private async getValueFromPath(module: any, lang: string, path: string): Promise<any> {
  if (path in this.specialPaths) {
    const result = this.specialPaths[path](module, lang);
    if (result instanceof Promise) {
      return await result;
    }
    return result;
  } else {
    return this.getNestedProperty(module, path);
  }
}

private getNestedProperty(obj: any, path: string): any {
  const pathSegments = path.split(".");

  // Use reduce to traverse the object structure
  return pathSegments.reduce((currentValue, segment) => {
    // Check if the part matches the pattern "arrayName[index]"
    const match = segment.match(/^(\w+)\[(\d+)]$/);

    if (match) {
      // match consists of the full match, the array name and the index
      const [_, arrayName, index] = match;
      return currentValue && currentValue[arrayName] && currentValue[arrayName][parseInt(index)];
    }

    return currentValue && currentValue[segment];
  }, obj);
}

private getSubmodules(module: any, lang: string): string {
  if (module.subModules && module.subModules.length > 0) {
    return module.subModules.map((subModule: any) => {
      return `${subModule.abbreviation}$\\quad$${subModule.translations[activeTranslationIndex].name}, ${this.translations[lang]?.submoduleRequired.true}`;
    }).join(" \\\\ ");
  } else {
    return "-";
  }
}
```