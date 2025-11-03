# Docker Template

Template production-ready pour Docker avec multi-stage builds, Docker Compose, et best practices.

## Caractéristiques

- ✅ Multi-stage builds pour optimiser la taille
- ✅ Docker Compose pour orchestration
- ✅ Health checks intégrés
- ✅ Gestion des secrets
- ✅ Réseaux Docker configurés
- ✅ Optimisations de cache

## Structure

```
.
├── Dockerfile              # Image principale
├── Dockerfile.dev         # Image de développement
├── docker-compose.yml      # Orchestration
├── docker-compose.dev.yml  # Développement
├── .dockerignore           # Fichiers exclus
└── README.md
```

## Utilisation

```bash
# Build
docker build -t __PROJECT_NAME__ .

# Run
docker run -p 8000:8000 __PROJECT_NAME__

# Docker Compose
docker-compose up -d
```

## Best Practices

- Utiliser multi-stage builds
- Minimiser les layers
- Utiliser .dockerignore
- Configurer health checks
- Utiliser des tags spécifiques
- Scanner les vulnérabilités
