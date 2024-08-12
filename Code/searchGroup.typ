```ts
this.courseService.getAll().subscribe(courses => {
  this.groupedModules = courses.map(course => {
    const courseLabel = course?.translations?.[activeTranslationIndex]?.name;
    const coursePath = `/faculty/${course.department.facultyId}/department/${course.department.id}/course/${course.id}`;

    const items = course.modules.map(module => {
      return {
        label: module.translations?.[activeTranslationIndex]?.name,
        value: `${coursePath}/module/${module.id}`
      };
    });

    return {
      label: courseLabel,
      items: items
    };
  });
});
```