```ts
export class LanguageService {
  constructor(private http: HttpClient) {}

  private languageURL: string = environment.backendURL + "language";

  languageSubject = new BehaviorSubject(this.languageCode);

  getLanguages() {
    return this.http.get<LanguageDto[]>(this.languageURL);
  }

 set languageCode(value: string) {
   this.languageSubject.next(value);
   localStorage.setItem('language', value);
 }

 get languageCode() {
   return localStorage.getItem('language')??"de";
 }
}
```