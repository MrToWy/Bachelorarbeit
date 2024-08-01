```ts
@Injectable()
export class InjectUser extends AuthGuard('jwt') {
  handleRequest(err: any, user: any) {
    return user;
  }
}
```