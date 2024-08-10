#import("../Template/customFunctions.typ"): *

#codly(annotations:(
  (
    start: 1,
    end: 14,
    label: <extractComplexFields>
  ),
  (
    start: 20,
    end: 22,
    label: <connectResponsible>
  ),
  (
    start: 47,
    end: 50,
    label: <clearModules2>
  ),
  (
    start: 51,
    end: 52,
    label: <upsert>
  )
),
highlights:(
  (line:12, label: <moduleData>),
  (line:18, label: <moduleData2>),
  (line:32, fill: green, label: <clearModules>),
  (line:65, fill: red, label: <upsert>),

  (line:60, fill: blue, label: <upsertFilter>),
)
)



```ts
async updateModule(moduleDto: ModuleDto) {
  const {
    id,
    degreeProgramId,
    groupId,
    translations,
    subModules,
    responsibleId,
    requirementsHardId,
    requirementsSoftId,
    requirementsSoft: requirementsSoftNew,
    requirementsHard: requirementsHardNew,
    ...moduleData
  } = moduleDto;

  const updateArgs = {
    where: { id },
    data: {
      ...moduleData,

      responsible: responsibleId ? {
        connect: { id: responsibleId }
      } : undefined,

      requirementsHard: {
        update: {
          requiredSemesters: requirementsHardNew.requiredSemesters,
          translations: {
            upsert: this.upsertTranslations(this.filterValidTranslations(requirementsHardNew.translations))
          },
          modules: {
            set: [], // remove all modules, before adding the new ones
            connect: requirementsHardNew.modules.map(module => ({
              id: module.id
            }))
          }
        }
      },

      requirementsSoft: {
        update: {
          requiredSemesters: requirementsSoftNew.requiredSemesters,
          translations: {
            upsert: this.upsertTranslations(this.filterValidTranslations(requirementsSoftNew.translations))
          },
          modules: {
            set: requirementsSoftNew.modules.map(module => ({
              id: module.id
            }))
          }
        }
      },
        ...
  }

  const createArgs = {
    ...
  };

  const upsertArgs = {
    where: { id },
    update: updateArgs.data,
    create: createArgs.data
  }

  const upsertedModule = await this.prisma.module.upsert(upsertArgs);
}
```