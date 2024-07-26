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