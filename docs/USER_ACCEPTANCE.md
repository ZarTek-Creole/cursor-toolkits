# 📋 Guide de Recette Utilisateur - Cursor Toolkits

## 🎯 Objectif

Ce document définit les critères d'acceptation utilisateur pour valider que le projet est prêt pour la production.

## ✅ Checklist de Validation

### 1. Installation

- [ ] Installation via `npm install -g` fonctionne
- [ ] Installation depuis source (`make install`) fonctionne
- [ ] La commande `cursor-init` est disponible dans le PATH
- [ ] La commande `generate-rules` est disponible dans le PATH
- [ ] Pas d'erreurs lors de l'installation

**Commandes de test**:
```bash
npm install -g
cursor-init --version
generate-rules --help
```

### 2. Création de Projet - Mode Interactif

- [ ] Le mode interactif démarre correctement
- [ ] Le banner s'affiche correctement
- [ ] Tous les templates sont listés
- [ ] La sélection de template fonctionne (1-14)
- [ ] La validation du nom de projet fonctionne
- [ ] Les features peuvent être sélectionnées
- [ ] La création de projet réussit
- [ ] Les fichiers sont correctement copiés
- [ ] Les placeholders sont remplacés

**Scénario de test**:
```bash
cursor-init
# Sélectionner: 1 (python-fastapi)
# Nom: test-project
# Features: docker,ci,tests
# Vérifier que le projet est créé
```

### 3. Création de Projet - Mode Direct

- [ ] Mode direct fonctionne avec `--stack` et `--name`
- [ ] Mode direct fonctionne avec `--features`
- [ ] Les erreurs sont claires si template invalide
- [ ] Les erreurs sont claires si nom invalide

**Scénarios de test**:
```bash
cursor-init --stack python-fastapi --name my-api
cursor-init --stack invalid-stack --name test  # Doit échouer avec message clair
cursor-init --stack python-fastapi --name "invalid name"  # Doit échouer
```

### 4. Liste et Information des Templates

- [ ] `cursor-init --list` affiche tous les templates
- [ ] `cursor-init --info <template>` affiche les infos
- [ ] Les informations sont complètes et correctes

**Scénarios de test**:
```bash
cursor-init --list
cursor-init --info python-fastapi
cursor-init --info invalid-template  # Doit échouer gracieusement
```

### 5. Génération de Règles

- [ ] `generate-rules <project>` fonctionne
- [ ] Les règles sont générées correctement
- [ ] Le format des règles est valide
- [ ] Les règles respectent les limites de tokens

**Scénario de test**:
```bash
mkdir test-project
cd test-project
# Créer quelques fichiers Python
generate-rules .
# Vérifier que .cursor/rules/ existe et contient des fichiers valides
```

### 6. Prompts et Commandes

- [ ] Les fichiers `.cursor/prompts.json` sont générés
- [ ] Les fichiers `.cursor/commands.json` sont générés
- [ ] Les prompts sont valides JSON
- [ ] Les commandes sont valides JSON
- [ ] Les prompts fonctionnent dans Cursor IDE
- [ ] Les commandes fonctionnent dans Cursor IDE

**Scénario de test**:
```bash
cursor-init --stack python-fastapi --name test
cd test
# Vérifier .cursor/prompts.json et .cursor/commands.json
python3 -m json.tool .cursor/prompts.json  # Doit être valide
python3 -m json.tool .cursor/commands.json  # Doit être valide
```

### 7. Templates Individuels

Pour chaque template, vérifier:

#### Python FastAPI
- [ ] Le projet se construit (`poetry install`)
- [ ] Les tests passent (`pytest`)
- [ ] Le serveur démarre (`uvicorn`)
- [ ] La couverture >90%

#### Next.js TypeScript
- [ ] Le projet se construit (`npm install`)
- [ ] Les tests passent (`npm test`)
- [ ] Le serveur démarre (`npm run dev`)
- [ ] Le build fonctionne (`npm run build`)

#### React + Vite
- [ ] Le projet se construit
- [ ] Les tests passent
- [ ] Le serveur démarre
- [ ] Le build fonctionne

#### Express TypeScript
- [ ] Le projet se construit
- [ ] Les tests passent
- [ ] Le serveur démarre

#### Symfony
- [ ] Les dépendances s'installent (`composer install`)
- [ ] Les tests passent (`php bin/phpunit`)
- [ ] Le serveur démarre

#### Bash Script
- [ ] Le script est exécutable
- [ ] Les tests BATS passent
- [ ] Le linting fonctionne

#### Docker
- [ ] Le Dockerfile build (`docker build`)
- [ ] Docker Compose fonctionne (`docker-compose up`)
- [ ] Les health checks fonctionnent

### 8. Validation et Tests

- [ ] `make validate` passe
- [ ] `make test` passe
- [ ] `make test:coverage` génère les rapports
- [ ] Tous les tests unitaires passent
- [ ] Tous les tests d'intégration passent

**Commandes de test**:
```bash
make validate
make test
make test:coverage
```

### 9. Documentation

- [ ] README.md est complet et à jour
- [ ] Tous les liens fonctionnent
- [ ] Les exemples de code fonctionnent
- [ ] La documentation est claire et compréhensible

### 10. Performance

- [ ] La création d'un projet prend <5 secondes
- [ ] La génération de règles prend <3 secondes
- [ ] Pas de ralentissement significatif avec plusieurs templates

## 🐛 Bugs Connus et Limitations

### Limitations Actuelles

1. **Génération de règles**: Feature en développement, fonctionnalité basique uniquement
2. **Templates incomplets**: Certains templates (go, rust, ruby) n'ont que prompts/commandes, pas de structure complète
3. **Dépendances**: Certaines dépendances peuvent nécessiter une installation manuelle

### Bugs Connus

- Aucun bug critique connu actuellement

## 📊 Critères de Succès

Le projet est considéré comme **prêt pour production** si:

- ✅ 100% des tests passent
- ✅ Couverture >90% pour tous les modules
- ✅ 0 vulnérabilité critique
- ✅ Tous les scénarios de test utilisateur passent
- ✅ Documentation complète
- ✅ Performance acceptable

## 🚨 Échecs Critiques

Le projet **NE DOIT PAS** être released si:

- ❌ Des TODOs bloquants existent dans le code production
- ❌ Des vulnérabilités critiques dans les dépendances
- ❌ Des tests échouent
- ❌ La documentation est incomplète
- ❌ Des fonctionnalités annoncées ne fonctionnent pas

## 📝 Notes de Recette

**Date de recette**: ___________  
**Testeur**: ___________  
**Version testée**: ___________  
**Résultat**: [ ] PASS [ ] FAIL  

**Commentaires**:
________________________________________
________________________________________
