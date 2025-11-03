# 🚀 Quick Start Guide

Guide de démarrage rapide pour utiliser cursor-toolkits.

## Installation

### Option 1 : Via npm (Recommandé)

```bash
npm install -g cursor-toolkits
```

### Option 2 : Depuis source

```bash
git clone https://github.com/your-username/cursor-toolkits.git
cd cursor-toolkits
make install
```

## Premiers Pas

### 1. Créer votre premier projet

```bash
# Mode interactif (le plus simple)
cursor-init
```

L'interface vous guidera étape par étape :
1. Entrez le nom de votre projet
2. Sélectionnez votre stack (Backend/Frontend/Full Stack)
3. Choisissez les fonctionnalités (Docker, CI, Tests, MCP)
4. Confirmez et c'est parti !

### 2. Exemples par Stack

#### Backend API Python

```bash
cursor-init --stack python-fastapi --name my-api
cd my-api
# Installer les dépendances
poetry install
# Lancer les tests
pytest
# Démarrer le serveur
uvicorn src.app.main:app --reload
```

#### Frontend Next.js

```bash
cursor-init --stack nextjs-typescript --name my-app
cd my-app
# Installer les dépendances
npm install
# Démarrer en développement
npm run dev
# Lancer les tests
npm test
```

#### API Express.js

```bash
cursor-init --stack express-typescript --name my-api
cd my-api
# Installer les dépendances
npm install
# Générer Prisma Client
npm run prisma:generate
# Démarrer en développement
npm run dev
```

## Fonctionnalités Avancées

### Générer des règles pour un projet existant

Si vous avez déjà un projet et voulez ajouter des règles Cursor optimisées :

```bash
generate-rules ./my-existing-project
```

Cette commande va :
1. Analyser votre projet
2. Détecter la stack utilisée
3. Générer des règles optimisées dans `.cursor/rules/`

### Explorer les templates disponibles

```bash
# Voir tous les templates
cursor-init --list

# Informations détaillées sur un template
cursor-init --info python-fastapi
```

### Configuration MCP

Chaque template inclut une configuration MCP d'exemple. Pour l'activer :

1. Copiez `.cursor/.mcp.json.example` vers `.cursor/.mcp.json`
2. Configurez vos tokens d'API
3. Redémarrez Cursor IDE

Exemple pour GitHub :

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "votre_token_ici"
      }
    }
  }
}
```

## Prochaines Étapes

1. **Explorer le code** - Chaque template inclut du code fonctionnel immédiatement utilisable
2. **Lire la documentation** - Consultez le README.md de votre template
3. **Personnaliser** - Adaptez les règles Cursor selon vos besoins
4. **Ajouter des fonctionnalités** - Le code est prêt pour que vous ajoutiez vos propres features

## Besoin d'aide ?

- 📖 [Guide Complet](GUIDE.md)
- 📋 [Catalogue des Templates](TEMPLATES.md)
- 🔌 [Guide MCP](MCP_SERVERS.md)
- 🤝 [Contribuer](CONTRIBUTING.md)

---

**Bon développement avec Cursor IDE ! 🎉**
