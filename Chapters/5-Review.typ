#import "../abbreviations.typ": *
#import "../Template/customFunctions.typ": *


= Refactoring

    await this.router.navigate(['faculty', module.facultyId, 'department', module.departmentId, 'course', module.courseId, 'module', module.id]);

    -> 

  async openDetailView(module: ModuleDto) {
    await this.router.navigate(['module', module.id], {relativeTo: this.route});
  }



= Review <review>

== Interview mit zukünftigem Dekan 

== Abweichungen zum Prototypen

== Überprüfung, ob Anforderungen erfüllt sind

== Ausblick

=== Ideen für zukünftige Features / Use-Cases
