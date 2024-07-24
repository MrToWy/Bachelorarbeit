```ts
async update(moduleDto: ModuleDto) {
    const {
      id,
      responsibleId,
      responsible,
      requirementsHardId,
      requirementsSoftId,
      requirementsHard: requirementsHardNew,
      requirementsSoft: requirementsSoftNew,
      degreeProgramId,
      groupId,
      group,
      translations,
      subModules,
      ...moduleData
    } = moduleDto;

    await this.prisma.$transaction(async (prisma) => {
      await prisma.module.update({
        where: { id },
        data: moduleData
      });

      await this.updateRequirements(prisma, moduleDto);
      await this.upsertModuleTranslations(prisma, moduleDto);
      await this.connectResponsible(prisma, moduleDto);
      await this.connectSubModules(prisma, moduleDto);
      await this.connectGroup(prisma, moduleDto);
    });
  }

  async connectResponsible(prisma: any, moduleDto: ModuleDto) {
    const { responsibleId, id } = moduleDto;

    if (!responsibleId) return;

    await prisma.module.update({
      where: { id },
      data: {
        responsible: responsibleId ? {
          connect: { id: responsibleId }
        } : undefined
      }
    });
  }


```