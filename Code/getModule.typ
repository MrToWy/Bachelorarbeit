```ts
  @Public()
  @Get(':id')
  findOne(@Req() request: Request, @Param('id') id: string) {
    const language = (request.headers as any)['language'];
    return this.moduleService.findOne(+id, language);
  }
```