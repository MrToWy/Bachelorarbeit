```ts
getIdFromSegment(segment: string): string | undefined {
  const segments = this.router.url.split("/");
  const segmentIndex = segments.indexOf(segment);
  return segmentIndex !== -1 ? segments[segmentIndex + 1] : undefined;
  }```