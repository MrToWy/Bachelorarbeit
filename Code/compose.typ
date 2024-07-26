```yml
name: studymodules_project

services:
  frontend:
    image: localhost/studymodules-frontend
    ports:
      - "80:80"
    environment:
      - NODE_ENV=production
    depends_on:
      - backend

  backend:
    image: localhost/studybase-backend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    volumes:
      - C:\Users\tobi\studybase\docker-volume:/app/docker-volume

  documentation:
    image: localhost/studymodules-documentation
    ports:
      - "8080:80"
      - "443:443"
    environment:
      - NODE_ENV=production
      - DOCUSAURUS_DOMAIN=localhost
      - DOCUSAURUS_EMAIL=letsencrypt@docusaurus.example
    volumes:
      - caddy_data:/data
      - caddy_config:/config

  latex-api:
    image: localhost/latex-api:latest
    ports:
      - "2345:8080"
    build: .
    command: make start
    environment:
      # SENTRY_DSN:
      CACHE_HOST: cache
    depends_on:
      - backend

  latex-poll-script:
    image: localhost/studymodules-latex:latest

volumes:
  caddy_data:
  caddy_config:
```