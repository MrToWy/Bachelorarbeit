#import("../Template/customFunctions.typ"): *

#codly(
highlights:(
  (line:0, fill:blue, label: <fromNodeAlpine>),
  (line:6, fill:red, label: <copyPackage>),
  (line:10, fill:blue, label: <copyAll>),
  (line:15, fill:blue, label: <copyFromBuild>),
),
annotations:(
  (start: 14, end: 18, label: <secondStage>),
)
)


```Dockerfile
FROM node:alpine as build

WORKDIR /project
RUN npm install -g @angular/cli

# only copy the package.json and package-lock.json to install dependencies (Efficient Layer Caching)
COPY package*.json ./
RUN npm ci

# copy the rest of the files
COPY . .
RUN npm run build


FROM nginx:alpine
COPY --from=build /project/dist/study-modules/browser /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```