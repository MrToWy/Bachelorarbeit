#import("../Template/customFunctions.typ"): *

#codly(
highlights:(
  (line:13, label: <canActivateLine>),
)
)


```ts
export class JwtAuthGuard extends AuthGuard('jwt') {

  canActivate(context: ExecutionContext) {

    const isPublic = this.reflector.get<boolean>(
      'isPublic',
      context.getHandler(),
    );

    if (isPublic) {
      return true;
    }
    
    return super.canActivate(context);
  }
}
```