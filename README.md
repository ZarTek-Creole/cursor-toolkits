# 🎯 cursor-toolkits

> **Le couteau suisse pour Cursor IDE** - Templates production-ready avec règles optimisées et intégration MCP

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](.version)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Cursor](https://img.shields.io/badge/cursor-%3E%3D1.7.0-purple.svg)](https://cursor.com)
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)](tests/)
[![Coverage](https://img.shields.io/badge/coverage-90%2B-success)](COVERAGE.md)

**cursor-toolkits** est un écosystème complet de templates optimisés pour maximiser votre productivité avec Cursor IDE. Chaque template inclut :

- ✅ **Règles optimisées token-safe** (`.cursor/rules/*.mdc` < 500 lignes)
- ✅ **Configuration MCP** prête à l'emploi
- ✅ **Code boilerplate fonctionnel** et production-ready
- ✅ **Tests automatisés** avec 90%+ de couverture
- ✅ **CI/CD configuré** (GitHub Actions)
- ✅ **Documentation complète**

## 🚀 Quick Start

### Installation

```bash
# Via npm (recommandé)
npm install -g cursor-toolkits

# Ou depuis source
git clone https://github.com/your-username/cursor-toolkits.git
cd cursor-toolkits
make install
```

### Créer un projet

```bash
# Mode interactif (recommandé) 🎨
cursor-init

# Mode direct
cursor-init --stack python-fastapi --name my-api

# Avec fonctionnalités
cursor-init --stack nextjs-typescript --name my-app --features docker,ci,tests

# Voir tous les templates
cursor-init --list

# Informations sur un template
cursor-init --info python-fastapi
```

## 📦 Templates Disponibles

### 🔧 Backend APIs

| Template | Stack | Features |
|----------|-------|----------|
| **python-fastapi** | FastAPI + SQLAlchemy 2.0 + PostgreSQL | Async, Docker, Redis, Tests |
| **python-django** | Django 5 + DRF + PostgreSQL | Admin, REST API, Tests |
| **express-typescript** | Express.js + TypeScript + Prisma | REST API, Jest, Docker |
| **nestjs** | NestJS + TypeScript + PostgreSQL | Modular, TypeORM, Tests |
| **symfony-api** | Symfony 7 + Doctrine ORM 3 | API Platform, Messenger, Tests |
| **php-api** | PHP 8.3 + Slim Framework | REST API, Composer, Tests |

### 🎨 Frontend

| Template | Stack | Features |
|----------|-------|----------|
| **nextjs-typescript** | Next.js 14 + TypeScript + TailwindCSS | App Router, SSR, Components |
| **react-vite** | React 18 + Vite + TypeScript | Fast HMR, TailwindCSS, Vitest |
| **vue3** | Vue 3 + Vite + TypeScript | Composition API, TailwindCSS, Vitest |

### 🚀 Full Stack

| Template | Stack | Features |
|----------|-------|----------|
| **t3-stack** | Next.js + tRPC + Prisma + TailwindCSS | Type-safe, Full-stack, Tests |

## ✨ Fonctionnalités

### 🎯 Interface Interactive Améliorée

```bash
cursor-init
# Interface visuelle avec menus, couleurs, et guide étape par étape
```

### 🔍 Analyse de Projets Existants

```bash
# Générer des règles pour un projet existant
generate-rules ./my-existing-project

# Analyser et suggérer des améliorations
cursor-init --from-existing ./project --analyze
```

### 🔌 Intégration MCP

Chaque template inclut une configuration MCP d'exemple :

- **GitHub** - Intégration GitHub
- **PostgreSQL** - Accès base de données
- **Redis** - Cache et sessions

### 📊 Tests et Coverage

- **90%+ de couverture** configurée pour tous les templates
- **Tests unitaires** complets
- **Tests d'intégration** inclus
- **CI/CD** configuré avec GitHub Actions

## 🏗️ Architecture

```
cursor-toolkits/
├── bin/
│   ├── cursor-init              # CLI principal
│   └── generate-rules           # Générateur de règles
├── lib/
│   ├── validators/               # Validation configs
│   ├── generators/              # Générateurs code
│   └── utils/                   # Utilitaires
├── templates/                   # Templates par technologie
│   ├── python-fastapi/
│   ├── nextjs-typescript/
│   ├── react-vite/
│   ├── express-typescript/
│   └── ...
├── docs/                        # Documentation complète
├── tests/                       # Tests automatisés
└── .github/workflows/           # CI/CD
```

## 📚 Documentation

- 📖 [Guide Complet](docs/GUIDE.md) - Guide d'utilisation détaillé
- 🎯 [Quick Start](docs/QUICK_START.md) - Démarrage rapide par stack
- 📋 [Templates Catalogue](docs/TEMPLATES.md) - Catalogue complet des templates
- 🔌 [MCP Servers](docs/MCP_SERVERS.md) - Guide intégration MCP
- ⚡ [Token Optimization](docs/TOKEN_OPTIMIZATION.md) - Optimisation consommation tokens
- 📊 [Coverage](COVERAGE.md) - Guide de couverture de code
- 🤝 [Contributing](docs/CONTRIBUTING.md) - Guidelines contribution

## 🧪 Tests

```bash
# Tous les tests
make test

# Tests par langage
make test:python
make test:node

# Coverage reports
make test:coverage

# Validation
make validate
```

## 🎓 Features Principales

### Règles Optimisées Token-Safe
- **Format `.mdc`** (standard Cursor >= 1.7.0)
- **< 500 lignes par fichier** (TOC-safe)
- **Modulaires** : règles séparées par domaine (API, testing, Docker)
- **Production-ready** : best practices incluses

### Intégration MCP
- **Configuration prête** dans `.cursor/.mcp.json.example`
- **Servers recommandés** par template
- **Documentation complète** pour chaque intégration

### Boilerplates Complets
- **Code fonctionnel immédiat** (pas de squelettes vides)
- **Tests inclus** (pytest, PHPUnit, Jest, Vitest)
- **CI/CD configuré** (GitHub Actions)
- **Docker ready** (Dockerfile + docker-compose.yml)

### CLI Intelligent
- **Interface interactive** avec menus visuels
- **Détection automatique** de stack existante
- **Génération de règles** pour projets existants
- **Validation** complète des inputs

## 🔧 Configuration Requise

- **Cursor IDE** >= 1.7.0
- **Python** >= 3.11 (pour templates Python)
- **Node.js** >= 18 (pour templates Node.js)
- **PHP** >= 8.3 (pour templates PHP)
- **Docker** (optionnel, pour templates avec conteneurs)

## 📝 Tokens & Optimisation

Chaque template respecte un budget token strict pour éviter les dépassements Cursor :

- **Python FastAPI** : 450 tokens max
- **Symfony API** : 500 tokens max
- **Next.js TypeScript** : 450 tokens max

> 💡 **Astuce** : Consultez [Token Optimization Guide](docs/TOKEN_OPTIMIZATION.md) pour optimiser votre utilisation Cursor.

## 🤝 Contribution

Les contributions sont les bienvenues ! Voir [CONTRIBUTING.md](docs/CONTRIBUTING.md) pour les guidelines.

### Ajouter un nouveau template

1. Créer le dossier dans `templates/`
2. Ajouter `template.json` avec métadonnées
3. Créer les règles dans `.cursor/rules/`
4. Ajouter les tests
5. Documenter dans `docs/TEMPLATES.md`

## 📄 License

MIT License - Voir [LICENSE](LICENSE) pour plus d'informations.

## 🙏 Acknowledgments

- [Cursor IDE](https://cursor.com) pour l'éditeur révolutionnaire
- Communauté Cursor pour les retours et améliorations
- Projets open-source inspirants (FastAPI, Symfony, Next.js, etc.)

---

**Made with ❤️ for the Cursor IDE community**

**🌟 Star ce projet si vous le trouvez utile !**
