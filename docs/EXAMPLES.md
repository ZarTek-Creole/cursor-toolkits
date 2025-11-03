# Exemples d'Utilisation - Cursor Toolkits

Ce document fournit des exemples concrets d'utilisation des prompts et commandes pour chaque template.

## 🐍 Python FastAPI

### Prompts

#### Créer un endpoint RESTful
```
@create_endpoint Crée un endpoint pour gérer les produits avec les routes GET /products, GET /products/{id}, POST /products, PUT /products/{id}, DELETE /products/{id}
```

#### Créer un modèle avec relations
```
@create_model Crée un modèle Order avec les champs : id (UUID), user_id (ForeignKey vers User), total (Decimal), status (Enum), created_at. Ajoute aussi la relation avec OrderItem
```

#### Ajouter l'authentification
```
@add_authentication Ajoute l'authentification JWT avec tokens expirant après 15 minutes et refresh tokens expirant après 7 jours
```

### Commandes

```bash
# Démarrer le serveur de développement
Cmd+Shift+P → start-dev

# Exécuter les tests avec coverage
Cmd+Shift+P → run-tests

# Créer une migration
Cmd+Shift+P → create-migration
# Puis entrer: "Add product table"
```

## ⚛️ Next.js TypeScript

### Prompts

#### Créer une page avec SEO optimisé
```
@create_page Crée une page /about avec un titre "À propos", description meta, et contenu avec TailwindCSS
```

#### Créer un composant réutilisable
```
@create_component Crée un composant Card dans components/ui/Card.tsx qui accepte title, description, imageUrl comme props et utilise TailwindCSS pour le style
```

#### Créer une route API
```
@create_api_route Crée une route API GET /api/users qui retourne la liste des utilisateurs depuis une base de données
```

### Commandes

```bash
# Démarrer le serveur de développement
Cmd+Shift+P → dev

# Vérifier les types TypeScript
Cmd+Shift+P → type-check

# Builder pour la production
Cmd+Shift+P → build
```

## ⚛️ React + Vite

### Prompts

#### Créer un composant avec état
```
@create_component Crée un composant Counter dans components/Counter.tsx avec un bouton qui incrémente un compteur, utilise useState
```

#### Créer un custom hook
```
@create_hook Crée un hook useFetch dans hooks/useFetch.ts qui prend une URL et retourne { data, loading, error }
```

#### Créer un Context API
```
@create_context Crée un Context pour gérer le thème (dark/light) avec un Provider ThemeProvider et un hook useTheme
```

### Commandes

```bash
# Démarrer Vite
Cmd+Shift+P → dev

# Ouvrir l'UI Vitest
Cmd+Shift+P → test-ui
```

## 🚀 Express.js TypeScript

### Prompts

#### Créer une route complète
```
@create_route Crée une route /api/products avec GET (liste), GET /:id (détail), POST (créer), PUT /:id (mettre à jour), DELETE /:id (supprimer)
```

#### Ajouter un modèle Prisma
```
@add_prisma_model Ajoute un modèle Product avec les champs : id (String @id @default(uuid())), name (String), price (Float), description (String?), createdAt (DateTime @default(now()))
```

### Commandes

```bash
# Générer Prisma Client
Cmd+Shift+P → prisma-generate

# Ouvrir Prisma Studio
Cmd+Shift+P → prisma-studio

# Exécuter les migrations
Cmd+Shift+P → prisma-migrate
```

## 🎯 NestJS

### Prompts

#### Créer un module complet
```
@create_module Crée un module Products avec un Controller ProductsController, un Service ProductsService, une Entity Product avec TypeORM, et des DTOs CreateProductDto et UpdateProductDto
```

#### Créer un Guard
```
@create_guard Crée un Guard JwtAuthGuard qui vérifie le token JWT dans le header Authorization
```

### Commandes

```bash
# Générer un module
Cmd+Shift+P → generate-module
# Puis entrer: products

# Générer un controller
Cmd+Shift+P → generate-controller
# Puis entrer: products
```

## 🐘 Symfony

### Prompts

#### Créer un Controller API
```
@create_controller Crée un ApiProductController avec les actions index, show, create, update, delete pour gérer les produits via API REST
```

#### Créer une Entity
```
@create_entity Crée une Entity Product avec les propriétés : name (string), price (decimal), description (text nullable), createdAt (datetime)
```

### Commandes

```bash
# Démarrer le serveur Symfony
Cmd+Shift+P → server-start

# Générer un Controller
Cmd+Shift+P → make-controller
# Puis entrer: ProductController

# Générer une Entity
Cmd+Shift+P → make-entity
# Puis entrer: Product
```

## 🟢 Vue 3

### Prompts

#### Créer un composant avec Composition API
```
@create_component Crée un composant UserProfile dans components/UserProfile.vue qui affiche le nom, email et avatar d'un utilisateur avec TailwindCSS
```

#### Créer un composable
```
@create_composable Crée un composable useApi dans composables/useApi.ts qui fait des appels API avec gestion de loading et erreurs
```

#### Créer un store Pinia
```
@create_store Crée un store cart dans stores/cart.ts pour gérer un panier d'achat avec addItem, removeItem, clearCart
```

### Commandes

```bash
# Démarrer Vite
Cmd+Shift+P → dev

# Exécuter les tests
Cmd+Shift+P → test
```

## 📝 Python Django

### Prompts

#### Créer une View DRF
```
@create_view Crée un ViewSet ProductViewSet dans l'app products avec les actions list, retrieve, create, update, destroy
```

#### Créer un Serializer
```
@create_serializer Crée un ProductSerializer pour le modèle Product avec validation des champs name (required, max_length=100) et price (required, min_value=0)
```

### Commandes

```bash
# Démarrer le serveur Django
Cmd+Shift+P → runserver

# Créer des migrations
Cmd+Shift+P → makemigrations

# Ouvrir le shell Django
Cmd+Shift+P → shell
```

## 🔷 T3 Stack

### Prompts

#### Créer un router tRPC
```
@create_trpc_router Crée un router products dans server/api/routers/products.ts avec les procedures getAll, getById, create, update, delete
```

#### Créer une page avec tRPC
```
@create_next_page Crée une page /products dans app/products/page.tsx qui affiche la liste des produits en utilisant trpc.products.getAll.useQuery()
```

### Commandes

```bash
# Pousser le schéma Prisma
Cmd+Shift+P → db-push

# Ouvrir Prisma Studio
Cmd+Shift+P → db-studio
```

## 🐘 PHP API (Slim)

### Prompts

#### Créer une route avec Controller
```
@create_route Crée une route GET /api/products qui utilise ProductController::index et retourne JSON
```

#### Créer un Controller
```
@create_controller Crée un ProductController dans src/Controllers/ProductController.php avec les méthodes index, show, create, update, delete
```

### Commandes

```bash
# Démarrer le serveur PHP
Cmd+Shift+P → serve

# Installer les dépendances
Cmd+Shift+P → composer-install
```

## 💡 Conseils Pro

1. **Combine les prompts** : Vous pouvez utiliser plusieurs prompts dans une même conversation
   ```
   @create_model Crée un modèle User
   @create_endpoint Crée les endpoints pour User
   @add_authentication Ajoute l'auth JWT
   ```

2. **Utilisez les variables** : Les prompts acceptent des variables entre crochets
   ```
   @create_service Crée un service pour [GESTION DES COMMANDES]
   ```

3. **Personnalisez** : Adaptez les prompts à vos besoins spécifiques
   ```
   @create_component Crée un composant Modal avec backdrop, animation, et fermeture sur Escape
   ```

4. **Tests intégrés** : Les prompts incluent toujours les tests, utilisez-les !
   ```
   @create_endpoint Crée un endpoint avec tests incluant les cas d'erreur
   ```

---

**Bon développement avec Cursor IDE ! 🚀**
