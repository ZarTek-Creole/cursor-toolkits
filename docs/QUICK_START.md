# Quick Start

## Créer un nouveau projet

### Python FastAPI

```bash
cursor-init --stack python-fastapi --name my-api
cd my-api
poetry install
docker-compose up -d
```

### Symfony API

```bash
cursor-init --stack symfony-api --name my-api
cd my-api
composer install
symfony serve
```

### Next.js TypeScript

```bash
cursor-init --stack nextjs-typescript --name my-app
cd my-app
npm install
npm run dev
```

## Analyse d'un projet existant

```bash
cursor-init --from-existing /path/to/project --generate-rules
```

