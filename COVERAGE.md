# Coverage Reports

Ce document décrit la stratégie de couverture de code pour cursor-toolkits.

## Objectifs

- **Couverture minimale**: 90% pour tous les composants
- **Objectif**: 100% de tests unitaires pour toutes les fonctions

## Structure de Coverage

### Python

- **Validators**: `lib/validators/check-token-limits.py`
- **Utils**: `lib/utils/`
- **FastAPI Template**: `templates/python-fastapi/src/`

**Commandes**:
```bash
# Tests avec coverage
pytest --cov=lib --cov-report=html --cov-report=term --cov-fail-under=90

# Template FastAPI
cd templates/python-fastapi
pytest --cov=src --cov-report=html --cov-report=term --cov-fail-under=90
```

### Node.js

- **Wrapper**: `bin/cursor-init-wrapper.js`
- **Next.js Template**: `templates/nextjs-typescript/src/`

**Commandes**:
```bash
# Tests avec coverage
npm run test:unit -- --coverage

# Template Next.js
cd templates/nextjs-typescript
npm test -- --coverage
```

### PHP/Symfony

- **Symfony Template**: `templates/symfony-api/src/`

**Commandes**:
```bash
cd templates/symfony-api
php bin/phpunit --coverage-text --coverage-clover=coverage.xml
```

### Bash Scripts

Les scripts bash sont testés via des tests d'intégration dans `tests/`.

## Rapports

Les rapports de coverage sont générés dans:
- Python: `htmlcov/index.html`
- Node.js: `coverage/index.html`
- PHP: `coverage.xml`

## CI/CD

Le pipeline CI/CD vérifie automatiquement que la couverture est >= 90% pour tous les composants.
