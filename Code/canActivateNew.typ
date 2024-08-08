```ts
async canActivate(context: ExecutionContext): Promise<boolean> {
  // canActivate() will inject the context of the current request
  // we need to call it first to be able to access the user later (@User() user:UserDto)
  let canActivate = super.canActivate(context);
  try {
    if (isObservable(canActivate)) {
      canActivate = await lastValueFrom(canActivate as Observable<boolean>);
    } else {
      canActivate = await canActivate;
    }
  } catch (UnauthorizedException) {
    canActivate = false;
  }

  const isPublic = this.reflector.get<boolean>(
    "isPublic",
    context.getHandler()
  );

  if (isPublic) {
    return true;
  }

  if (context.getHandler().name === "login") return true;
  if (context.getHandler().name === "license") return true;

  return canActivate;
}
```