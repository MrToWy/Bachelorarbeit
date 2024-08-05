```ts
onModuleChange() {
  this.moduleChange.emit(this.module);
}
@Input() module!: ModuleDetail;
@Output() moduleChange = new EventEmitter<any>();
```