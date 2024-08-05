```ts
@UseGuards(InjectUser)
@Public()
@Get(':id')
findOne(@User() user:UserDto, @Req() request: Request, @Param('id') id: string) {
[...]
```