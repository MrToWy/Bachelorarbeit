#import("../Template/customFunctions.typ"): *

#codly(
highlights:(
  (line:0, fill:red, label: <setImage>),
  (line:5, fill:green, label: <installPackage>),
),
)



```Dockerfile
FROM python:3.11.9-alpine3.20

COPY . /app
WORKDIR /app

RUN pip install requests

RUN crontab /app/crontab

# log to stdout for easier debugging
CMD ["crond", "-f", "-l", "2"]
```