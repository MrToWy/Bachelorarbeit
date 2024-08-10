```ts
this.courseService.getAll().subscribe(courses => {
  this.groupedModules = courses.map(course => {
    return {
      label: course?.translations?.at(activeTranslationIndex)?.name ?? '',
      items: course.modules.map(module => {
        return {
          label: module.translations?.at(activeTranslationIndex)?.name,
          value: '/faculty/' + course.department.facultyId + '/department/' + course.department.id + '/course/' + course.id + '/module/' + module.id
        }
      })
    }
  });
});
```