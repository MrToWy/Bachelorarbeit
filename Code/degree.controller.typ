```ts
@ApiTags('Degrees')
@Controller('degrees')
export class DegreeController {
  constructor(
    private degreeService: DegreeService
  ) {}

  @Get('')
  findAll() {
    return this.degreeService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Req() request: Request): Promise<any> {
    const language = (request.headers as any)['language'];
    return this.degreeService.findById(+id, language);
  }
}
```