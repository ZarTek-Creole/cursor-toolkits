# 🔧 Cursor Toolkits

**Production-ready templates for Cursor IDE** with optimized rules, MCP integration, predefined prompts, and custom commands.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Tests](https://img.shields.io/badge/tests-passing-brightgreen)](https://github.com/your-username/cursor-toolkits)

## ✨ Fonctionnalités

- 🎯 **Templates Production-Ready**: 10+ templates pour différentes technologies
- 📝 **Règles Cursor Optimisées**: Génération automatique de règles `.cursor/rules/*.mdc`
- 🔌 **Intégration MCP**: Configuration MCP pour chaque template
- 💬 **Prompts Prédéfinis**: Prompts contextuels par type de projet
- ⌨️ **Commandes Personnalisées**: Commandes shell intégrées à Cursor IDE
- ✅ **Tests Complets**: Coverage >90%, tests unitaires et d'intégration
- 📚 **Documentation Complète**: Guides, exemples, et best practices

## 🚀 Installation

```bash
# Via npm (recommandé)
npm install -g cursor-toolkits

# Ou depuis source
git clone https://github.com/your-username/cursor-toolkits.git
cd cursor-toolkits
make install
```

## 📖 Utilisation Rapide

### Créer un nouveau projet

```bash
# Mode interactif
cursor-init

# Mode direct
cursor-init --stack python-fastapi --name my-api --features docker,ci,tests
```

### Lister les templates disponibles

```bash
cursor-init --list
cursor-init --info python-fastapi
```

## 📦 Templates Disponibles

### Backend

- **Python FastAPI**: FastAPI + SQLAlchemy 2.0 + Pydantic 2 + PostgreSQL + Redis
- **Python Django**: Django REST Framework + PostgreSQL
- **Symfony API**: Symfony 7 + Doctrine ORM 3
- **PHP API**: Slim Framework + Eloquent

### Frontend & Full-Stack

- **Next.js TypeScript**: Next.js 14 + TypeScript + TailwindCSS + App Router
- **React + Vite**: React 18 + Vite + TypeScript + TailwindCSS + Vitest
- **Vue 3**: Vue 3 + Vite + TypeScript + TailwindCSS + Composition API
- **Express TypeScript**: Express.js + TypeScript + Prisma + Jest
- **NestJS**: NestJS + TypeORM + PostgreSQL + Jest
- **T3 Stack**: Next.js + tRPC + Prisma + TailwindCSS

### DevOps & Tools

- **Bash Script**: Scripts Bash avec BATS pour tests
- **Docker**: Multi-stage builds + Docker Compose

## 🎯 Prompts Prédéfinis

Chaque template inclut des prompts prédéfinis pour accélérer le développement :

- Créer des endpoints/modèles/composants
- Ajouter des tests
- Configurer des features
- Et plus encore...

**Documentation complète**: [`docs/PROMPTS_AND_COMMANDS.md`](docs/PROMPTS_AND_COMMANDS.md)

## ⌨️ Commandes Personnalisées

Chaque template inclut des commandes shell personnalisées pour Cursor IDE :

- Lancer les tests
- Démarrer le serveur de développement
- Linter le code
- Et plus encore...

**Documentation complète**: [`docs/PROMPTS_AND_COMMANDS.md`](docs/PROMPTS_AND_COMMANDS.md)

## 📚 Documentation

- **[Guide Complet](docs/GUIDE.md)**: Documentation détaillée
- **[Démarrage Rapide](docs/QUICK_START.md)**: Guide rapide
- **[Prompts & Commandes](docs/PROMPTS_AND_COMMANDS.md)**: Documentation complète
- **[Exemples](docs/EXAMPLES.md)**: Exemples d'utilisation
- **[Audit Complet](docs/AUDIT_COMPLET.md)**: Analyse du projet
- **[Plan d'Action](docs/PLAN_ACTION.md)**: Roadmap technique
- **[Maintenance](docs/MAINTENANCE.md)**: Plan de maintenance

## 🧪 Tests

```bash
# Tous les tests
make test

# Tests avec couverture
make test:coverage-check

# Audit de sécurité
make test:security

# Tests spécifiques
make test:python
make test:node
```

## 🔍 Qualité et Sécurité

- ✅ Couverture de code >90% (objectif)
- ✅ Tests automatisés (unitaires + intégration)
- ✅ Audit de sécurité des dépendances
- ✅ Validation des règles Cursor
- ✅ Vérification des limites de tokens

## 📋 Structure du Projet

```
cursor-toolkits/
├── bin/                 # Scripts CLI
├── lib/                 # Bibliothèques
│   ├── generators/      # Générateurs (rules, prompts, commands)
│   ├── validators/      # Validateurs
│   ├── prompts/         # Prompts prédéfinis (JSON)
│   └── commands/        # Commandes personnalisées (JSON)
├── templates/           # Templates de projets
├── docs/                # Documentation
│   └── adr/            # Architecture Decision Records
├── scripts/             # Scripts utilitaires
├── tests/              # Tests
└── Makefile            # Automatisation
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Voir [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) pour plus de détails.

## 📄 License

MIT License - voir [`LICENSE`](LICENSE) pour plus de détails.

## 🙏 Remerciements

- Cursor IDE pour l'outil exceptionnel
- La communauté open-source pour l'inspiration

---

**Note**: Ce projet est en développement actif. Voir [`docs/AUDIT_COMPLET.md`](docs/AUDIT_COMPLET.md) pour l'état actuel et [`docs/PLAN_ACTION.md`](docs/PLAN_ACTION.md) pour la roadmap.
