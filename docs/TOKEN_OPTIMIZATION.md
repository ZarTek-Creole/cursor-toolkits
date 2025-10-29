# Token Optimization Guide

Guide pour optimiser la consommation de tokens dans Cursor IDE.

## Token Budgets

Chaque template respecte un budget strict :

- Python FastAPI: 450 tokens
- Symfony API: 500 tokens
- Next.js TypeScript: 450 tokens

## Best Practices

### 1. Règles Concises

- Utiliser format `.mdc` modulaire
- Une règle = un domaine (API, testing, Docker)
- Maximum 500 lignes par fichier

### 2. Structure Modulaire

```
.cursor/rules/
├── fastapi-basic.mdc
├── testing.mdc
└── docker.mdc
```

### 3. Contenu Optimisé

- Points essentiels uniquement
- Exemples courts et pertinents
- Restrictions claires (❌)

## Vérification

```bash
make check:tokens
```

