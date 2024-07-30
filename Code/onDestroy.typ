```ts
 ngOnDestroy(): void {
    if (this.intervalId) {
      clearInterval(this.intervalId);
    }

    if (this.languageSubscription) {
      this.languageSubscription.unsubscribe();
    }
  }
```