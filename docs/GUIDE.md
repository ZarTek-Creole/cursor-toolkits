# Cursor Toolkits - Guide Complet

## 🎯 Vue d'ensemble

Cursor Toolkits est votre couteau suisse pour créer des projets production-ready avec Cursor IDE. Il fournit des templates optimisés, des règles intelligentes, et une expérience de développement améliorée.

## 🚀 Démarrage Rapide

### Installation

```bash
# Cloner le repository
git clone https://github.com/your-username/cursor-toolkits.git
cd cursor-toolkits

# Installer globalement
make install

# Ou installer via npm
npm install -g
```

### Créer un nouveau projet

```bash
# Mode interactif (recommandé)
cursor-init

# Mode direct
cursor-init --stack python-fastapi --name my-api

# Avec fonctionnalités
cursor-init --stack nextjs-typescript --name my-app --features docker,ci,tests
```

## 📚 Templates Disponibles

### Backend APIs

#### Python FastAPI
```bash
cursor-init --stack python-fastapi --name my-api
```
- FastAPI + SQLAlchemy 2.0
- PostgreSQL + Redis
- Tests avec pytest
- Docker configuré

#### Python Django
```bash
cursor-init --stack python-django --name my-project
```
- Django 5 + DRF
- PostgreSQL
- Tests avec pytest
- Admin panel inclus

#### Express.js
```bash
cursor-init --stack express-typescript --name my-api
```
- Express.js + TypeScript
- Prisma ORM
- Tests avec Jest
- API RESTful

#### NestJS
```bash
cursor-init --stack nestjs --name my-api
```
- NestJS + TypeScript
- TypeORM + PostgreSQL
- Architecture modulaire
- Tests complets

#### Symfony
```bash
cursor-init --stack symfony-api --name my-api
```
- Symfony 7
- Doctrine ORM 3
- API Platform ready
- Tests PHPUnit

### Frontend

#### Next.js
```bash
cursor-init --stack nextjs-typescript --name my-app
```
- Next.js 14 + App Router
- TypeScript strict
- TailwindCSS
- Server Components

#### React + Vite
```bash
cursor-init --stack react-vite --name my-app
```
- React 18
- Vite 5
- TypeScript
- TailwindCSS

#### Vue 3
```bash
cursor-init --stack vue3 --name my-app
```
- Vue 3 Composition API
- Vite 5
- TypeScript
- TailwindCSS

## 🔧 Fonctionnalités Avancées

### Générer des règles pour un projet existant

```bash
# Analyser et générer des règles
generate-rules ./my-existing-project

# Avec répertoire de sortie personnalisé
generate-rules ./my-project --output ./custom-rules

# Forcer l'écrasement
generate-rules ./my-project --force
```

### Configuration MCP

Chaque template inclut une configuration MCP d'exemple. Activez les serveurs MCP dans `.cursor/.mcp.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### Listes des templates

```bash
# Voir tous les templates disponibles
cursor-init --list

# Informations sur un template
cursor-init --info python-fastapi
```

## 📋 Règles Cursor

Chaque template inclut des règles optimisées pour Cursor IDE:

- **Token-safe**: < 500 lignes par fichier
- **Modulaires**: Séparées par domaine
- **Production-ready**: Best practices incluses
- **Testées**: Couverture 90%+

### Structure des règles

```
.cursor/
├── rules/
│   ├── fastapi-basic.mdc      # Règles principales
│   ├── testing.mdc            # Règles de test
│   └── docker.mdc             # Règles Docker
└── .mcp.json.example          # Configuration MCP
```

## 🧪 Tests et Coverage

Tous les templates incluent une configuration de tests complète:

```bash
# Python
cd templates/python-fastapi
pytest --cov=src --cov-report=html

# Node.js
cd templates/express-typescript
npm test -- --coverage

# PHP
cd templates/symfony-api
php bin/phpunit --coverage-text
```

## 🎨 Personnalisation

### Ajouter vos propres règles

1. Créez un fichier `.mdc` dans `.cursor/rules/`
2. Suivez le format des règles existantes
3. Redémarrez Cursor IDE

### Créer un template personnalisé

1. Copiez un template existant
2. Modifiez les fichiers selon vos besoins
3. Ajoutez `template.json` avec les métadonnées
4. Créez les règles dans `.cursor/rules/`

## 🔌 Extensions et Plugins

### Intégration avec autres outils

- **GitHub Actions**: CI/CD configuré
- **Docker**: Containers prêts à l'emploi
- **Prisma/TypeORM**: Migrations incluses
- **Testing**: Frameworks configurés

## 📖 Documentation Complète

- [Installation](INSTALLATION.md)
- [Templates](TEMPLATES.md)
- [MCP Servers](MCP_SERVERS.md)
- [Token Optimization](TOKEN_OPTIMIZATION.md)
- [Contributing](CONTRIBUTING.md)

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/your-username/cursor-toolkits/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-username/cursor-toolkits/discussions)
- **Documentation**: [docs/](docs/)

## 📝 Changelog

Voir [CHANGELOG.md](../CHANGELOG.md) pour les versions et changements.

## 🤝 Contribution

Les contributions sont les bienvenues! Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour les guidelines.

---

**Made with ❤️ for the Cursor IDE community**
