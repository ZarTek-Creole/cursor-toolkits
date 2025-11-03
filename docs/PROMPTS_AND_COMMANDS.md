# Prompts et Commandes Cursor

Ce document explique comment utiliser les prompts prédéfinis et les commandes personnalisées inclus dans chaque template.

## 📝 Prompts Prédéfinis

Chaque template inclut des prompts prédéfinis dans `.cursor/prompts.json`. Ces prompts sont optimisés pour chaque technologie et vous permettent de générer rapidement du code suivant les best practices.

### Utilisation des Prompts

Dans Cursor IDE, vous pouvez utiliser les prompts de deux façons :

1. **Via le chat** : Mentionnez le nom du prompt dans votre conversation
2. **Via les commandes** : Utilisez `/prompt [nom]` dans le chat

### Prompts par Template

#### Python FastAPI

- `create_endpoint` - Créer un nouvel endpoint RESTful
- `create_model` - Créer un modèle SQLAlchemy
- `create_service` - Créer un service pour la logique métier
- `add_middleware` - Ajouter un middleware FastAPI
- `create_migration` - Créer une migration Alembic
- `optimize_query` - Optimiser une requête SQLAlchemy
- `add_authentication` - Ajouter l'authentification JWT

**Exemple** :
```
@create_endpoint Crée un endpoint pour gérer les produits
```

#### Next.js TypeScript

- `create_page` - Créer une nouvelle page Next.js
- `create_component` - Créer un composant React réutilisable
- `create_api_route` - Créer une route API
- `create_client_component` - Créer un Client Component
- `add_form` - Créer un formulaire avec validation
- `optimize_seo` - Optimiser le SEO d'une page

**Exemple** :
```
@create_component Crée un composant UserCard pour afficher les informations utilisateur
```

#### React + Vite

- `create_component` - Créer un composant React
- `create_hook` - Créer un custom hook
- `create_context` - Créer un Context API
- `add_state_management` - Ajouter la gestion d'état

#### Express.js TypeScript

- `create_route` - Créer une nouvelle route Express
- `create_middleware` - Créer un middleware
- `add_prisma_model` - Ajouter un modèle Prisma
- `create_service` - Créer un service

#### NestJS

- `create_module` - Créer un module complet NestJS
- `create_guard` - Créer un Guard
- `create_interceptor` - Créer un Interceptor
- `add_entity` - Ajouter une Entity TypeORM

#### Symfony

- `create_controller` - Créer un Controller Symfony
- `create_entity` - Créer une Entity Doctrine
- `create_service` - Créer un Service
- `create_form` - Créer un FormType

#### Vue 3

- `create_component` - Créer un composant Vue 3
- `create_composable` - Créer un composable
- `create_store` - Créer un store Pinia

## ⚡ Commandes Personnalisées

Chaque template inclut des commandes personnalisées dans `.cursor/commands.json`. Ces commandes sont disponibles dans la palette de commandes Cursor (`Cmd/Ctrl + Shift + P`).

### Utilisation des Commandes

1. Ouvrez la palette de commandes (`Cmd/Ctrl + Shift + P`)
2. Tapez le nom de la commande
3. La commande s'exécute dans le terminal intégré

### Commandes par Template

#### Python FastAPI

- `run-tests` - Exécuter tous les tests avec coverage
- `start-dev` - Démarrer le serveur de développement
- `format-code` - Formater le code avec ruff
- `lint-code` - Linter le code avec ruff
- `create-migration` - Créer une migration Alembic
- `run-migration` - Exécuter les migrations

#### Next.js TypeScript

- `dev` - Démarrer le serveur de développement
- `build` - Builder pour la production
- `test` - Exécuter les tests avec coverage
- `lint` - Linter le code
- `type-check` - Vérifier les types TypeScript

#### React + Vite

- `dev` - Démarrer Vite
- `build` - Builder pour la production
- `test` - Exécuter les tests Vitest
- `test-ui` - Ouvrir l'UI Vitest
- `lint` - Linter le code

#### Express.js TypeScript

- `dev` - Démarrer le serveur Express
- `build` - Builder TypeScript
- `test` - Exécuter les tests Jest
- `prisma-generate` - Générer Prisma Client
- `prisma-migrate` - Exécuter les migrations Prisma
- `prisma-studio` - Ouvrir Prisma Studio

#### NestJS

- `dev` - Démarrer NestJS en mode développement
- `build` - Builder l'application
- `test` - Exécuter les tests
- `test-e2e` - Exécuter les tests e2e
- `generate-module` - Générer un module NestJS
- `generate-controller` - Générer un controller
- `generate-service` - Générer un service

#### Symfony

- `server-start` - Démarrer le serveur Symfony
- `test` - Exécuter les tests PHPUnit
- `make-controller` - Générer un Controller
- `make-entity` - Générer une Entity
- `make-migration` - Générer une migration
- `migrate` - Exécuter les migrations

#### Vue 3

- `dev` - Démarrer Vite
- `build` - Builder pour la production
- `test` - Exécuter les tests Vitest
- `lint` - Linter le code

## 🔧 Personnalisation

### Ajouter vos propres Prompts

1. Éditez `.cursor/prompts.json` dans votre projet
2. Ajoutez un nouvel objet dans le tableau `prompts` :

```json
{
  "prompts": [
    {
      "name": "mon_prompt",
      "prompt": "Votre prompt personnalisé ici",
      "category": "development"
    }
  ]
}
```

3. Redémarrez Cursor IDE ou rechargez la fenêtre

### Ajouter vos propres Commandes

1. Éditez `.cursor/commands.json` dans votre projet
2. Ajoutez une nouvelle commande dans le tableau `commands` :

```json
{
  "commands": [
    {
      "name": "ma-commande",
      "description": "Description de la commande",
      "command": "commande-shell-ici",
      "type": "shell"
    }
  ]
}
```

3. Redémarrez Cursor IDE

## 📚 Références

- [Documentation Cursor Commands](https://cursor.com/docs/agent/chat/commands)
- [Exemples de Commandes](https://github.com/hamzafer/cursor-commands)

## 💡 Conseils

1. **Utilisez les prompts contextuels** : Les prompts sont optimisés pour chaque stack
2. **Combine les prompts** : Vous pouvez utiliser plusieurs prompts dans une conversation
3. **Personnalisez** : Adaptez les prompts à vos besoins spécifiques
4. **Partagez** : Créez vos propres prompts et partagez-les avec l'équipe

---

**Bon développement avec Cursor IDE ! 🚀**
