# 🎯 cursor-toolkits

> Production-ready templates for Cursor IDE with optimized rules and MCP integration

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](.version)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Cursor](https://img.shields.io/badge/cursor-%3E%3D1.7.0-purple.svg)](https://cursor.com)
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)](tests/)

**cursor-toolkits** est un écosystème de templates optimisés pour maximiser votre productivité avec Cursor IDE. Chaque template inclut :

- ✅ **Règles optimisées token-safe** (`.cursor/rules/*.mdc` < 500 lignes)
- ✅ **Configuration MCP** prête à l'emploi
- ✅ **Code boilerplate fonctionnel** et production-ready
- ✅ **Tests automatisés** et CI/CD configurés
- ✅ **Documentation complète**

## 📦 Templates Disponibles

### 🐍 Python FastAPI
**Stack** : FastAPI + SQLAlchemy 2.0 + Pydantic 2 + PostgreSQL + Redis  
**Token budget** : 450 tokens  
**Features** : Async, authentication, Docker, CI/CD  

### 🐘 Symfony API
**Stack** : Symfony 7 + Doctrine ORM 3 + PHP 8.3+  
**Token budget** : 500 tokens  
**Features** : Messenger async, security, API Platform ready  

### ⚛️ Next.js TypeScript
**Stack** : Next.js 14 + TypeScript + TailwindCSS  
**Token budget** : 450 tokens  
**Features** : App Router, SSR, components, CI/CD  

## 🚀 Quick Start

### Installation

```bash
# Clone ou télécharge cursor-toolkits
cd cursor-toolkits

# Installation
make install
```

### Créer un nouveau projet

```bash
# Mode interactif
cursor-init

# Mode direct
cursor-init --stack python-fastapi --name my-api --features docker,ci

# Analyser un projet existant
cursor-init --from-existing /path/to/project --generate-rules
```

### Exemples d'usage

```bash
# Template FastAPI complet
cursor-init --stack python-fastapi --name my-api

# Template Symfony avec MCP
cursor-init --stack symfony-api --name my-api --mcp github,postgres

# Template Next.js avec Tailwind
cursor-init --stack nextjs-typescript --name my-app --features tailwind,tests
```

## 📚 Documentation

- 📖 [Installation Guide](docs/INSTALLATION.md) - Installation détaillée (Debian, macOS, WSL)
- 🎯 [Quick Start](docs/QUICK_START.md) - Démarrage rapide par stack
- 📋 [Templates Catalogue](docs/TEMPLATES.md) - Catalogue complet des templates
- 🔌 [MCP Servers](docs/MCP_SERVERS.md) - Guide intégration MCP
- ⚡ [Token Optimization](docs/TOKEN_OPTIMIZATION.md) - Optimisation consommation tokens
- 🤝 [Contributing](docs/CONTRIBUTING.md) - Guidelines contribution

## 🏗️ Architecture

```
cursor-toolkits/
├── bin/
│   └── cursor-init           # CLI principal (bash + npm wrapper)
├── lib/
│   ├── validators/           # Validation configs
│   ├── generators/           # Générateurs code
│   └── analyzers/            # Analyse projets existants
├── templates/                # Templates par technologie
│   ├── python-fastapi/
│   ├── symfony-api/
│   └── nextjs-typescript/
├── docs/                     # Documentation complète
├── tests/                    # Tests automatisés
└── Makefile                  # Commandes principales
```

## 🧪 Tests

```bash
# Lancer tous les tests
make test

# Validation des templates
make validate

# Vérifier limites tokens
make check:tokens
```

## 🎓 Features Principales

### Règles Optimisées Token-Safe
- **Format `.mdc`** (nouveau standard Cursor >= 1.7.0)
- **< 500 lignes par fichier** (TOC-safe)
- **Modulaires** : règles séparées par domaine (API, testing, Docker)

### Intégration MCP
- **Configuration prête** dans `.cursor/.mcp.json.example`
- **Servers recommandés** par template
- **Documentation complète** pour chaque intégration

### Boilerplates Complets
- **Code fonctionnel immédiat** (pas de squelettes vides)
- **Tests inclus** (pytest, PHPUnit, Jest)
- **CI/CD configuré** (GitHub Actions)

### CLI Intelligent
- **Détection automatique** de stack existante
- **Mode interactif** avec questions guidées
- **Génération de règles** pour projets existants

## 🔧 Configuration Requise

- **Cursor IDE** >= 1.7.0
- **Python** >= 3.11 (pour templates Python)
- **Node.js** >= 18 (pour templates Node.js)
- **PHP** >= 8.3 (pour templates Symfony)
- **Docker** (optionnel, pour templates avec conteneurs)

## 📝 Tokens & Optimisation

Chaque template respecte un budget token strict pour éviter les dépassements Cursor :

- **Python FastAPI** : 450 tokens max
- **Symfony API** : 500 tokens max
- **Next.js TypeScript** : 450 tokens max

> 💡 **Astuce** : Consultez [Token Optimization Guide](docs/TOKEN_OPTIMIZATION.md) pour optimiser votre utilisation Cursor.

## 🤝 Contribution

Les contributions sont les bienvenues ! Voir [CONTRIBUTING.md](docs/CONTRIBUTING.md) pour les guidelines.

## 📄 License

MIT License - Voir [LICENSE](LICENSE) pour plus d'informations.

## 🙏 Acknowledgments

- [Cursor IDE](https://cursor.com) pour l'éditeur révolutionnaire
- Communauté Cursor pour les retours et améliorations
- Projets open-source inspirants (FastAPI, Symfony, Next.js)

---

**Made with ❤️ for the Cursor IDE community**

