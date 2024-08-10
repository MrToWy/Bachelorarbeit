#import("../Template/customFunctions.typ"): *

#codly(
highlights:(
  (line:0, fill:blue, label: <apiTags>),
  (line:1, fill:green, label: <controllerDecorator>),
  (line:7, fill:yellow, label: <getDecorator>),
),
annotations:(
  (start: 3, end: 5, label: <constructor>),
)
)

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