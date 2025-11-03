# Changelog

Tous les changements notables de ce projet seront documentés dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

## [Unreleased]

### À Venir
- Templates complets pour Go, Rust, Ruby
- Interface web pour génération de projets
- Plugins pour autres IDEs

## [1.1.0] - 2025-01-28

### Ajouté
- **Audit Complet**: Documentation complète de l'état du projet (`docs/AUDIT_COMPLET.md`)
- **Plan d'Action**: Roadmap technique détaillée (`docs/PLAN_ACTION.md`)
- **Tests de Performance**: Benchmarks pour génération de projets (`tests/performance/`)
- **Tests de Sécurité**: Validation inputs, détection secrets (`tests/test_security.py`)
- **Scripts d'Automatisation**:
  - `scripts/check-coverage.sh`: Vérification couverture globale
  - `scripts/audit-security.sh`: Audit sécurité dépendances
  - `scripts/complexity-analysis.sh`: Analyse complexité cyclomatique
- **CI/CD Amélioré**:
  - Workflow de sécurité hebdomadaire (`.github/workflows/security-audit.yml`)
  - Workflow de couverture (`.github/workflows/coverage.yml`)
  - Configuration Dependabot (`.github/dependabot.yml`)
- **Documentation Technique**:
  - Architecture Decision Records (ADR) dans `docs/adr/`
  - Guide de recette utilisateur (`docs/USER_ACCEPTANCE.md`)
  - Plan de maintenance (`docs/MAINTENANCE.md`)
  - Politique de sécurité (`SECURITY.md`)
- **Modèles Fonctionnels**: 
  - Modèles `Item` et `User` pour FastAPI
  - Endpoints implémentés avec vraies requêtes DB
- **Tests Unitaires**: Tests pour `prompts_generator.py`

### Modifié
- **Résolution TODOs**: Tous les TODOs critiques résolus
- **README**: Mis à jour avec nouvelles sections
- **Makefile**: Nouvelles commandes (`test:coverage-check`, `test:security`, `complexity`)

### Sécurité
- Audit automatique des dépendances (hebdomadaire)
- Scan de secrets dans le code
- Validation stricte des inputs

## [1.0.0] - 2025-01-XX

### Ajouté
- Templates initiaux (FastAPI, Symfony, Next.js, React, Vue, Express, NestJS)
- Système de génération de règles Cursor
- Prompts prédéfinis et commandes personnalisées
- Intégration MCP
- Tests de base
- Documentation initiale

---

## Types de Changements

- `Ajouté` pour les nouvelles fonctionnalités
- `Modifié` pour les changements dans les fonctionnalités existantes
- `Déprécié` pour les fonctionnalités bientôt supprimées
- `Supprimé` pour les fonctionnalités supprimées
- `Corrigé` pour les corrections de bugs
- `Sécurité` pour les vulnérabilités corrigées
