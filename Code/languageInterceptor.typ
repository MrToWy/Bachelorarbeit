```ts
export class LanguageInterceptor implements HttpInterceptor {
  private language: string;

  constructor(private languageService: LanguageService) {
    this.language = this.languageService.languageCode;
    this.languageService.languageSubject.subscribe((language) => {
      this.language = language;
    });
  }

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    if (req.headers.has('language')) {
      return next.handle(req);
    }

    if (this.language) {
      const newRequest = req.clone({
        setHeaders: {
          'language': this.language.toUpperCase()
        }
      });
      return next.handle(newRequest);
    }
    return next.handle(req);
  }
}
```