# 📋 Checklist de Revue de Code

Ce document définit les critères de revue de code pour le projet Cursor Toolkits.

## 🎯 Objectifs

- Maintenir la qualité du code
- Réduire les bugs
- Améliorer la maintenabilité
- Partager les connaissances

## ✅ Checklist Générale

### 1. Fonctionnalité
- [ ] Le code remplit le besoin exprimé
- [ ] Le code fonctionne comme prévu
- [ ] Les cas limites sont gérés
- [ ] Les erreurs sont gérées correctement

### 2. Qualité du Code
- [ ] Le code est lisible et compréhensible
- [ ] Les noms de variables/fonctions sont descriptifs
- [ ] Pas de duplication de code (DRY)
- [ ] Les fonctions sont focal concernées (<50 lignes idéalement)
- [ ] La complexité cyclomatique est raisonnable (<10)

### 3. Tests
- [ ] Des tests unitaires existent pour le nouveau code
- [ ] Les tests couvrent les cas normaux et limites
- [ ] Les tests sont maintenables et clairs
- [ ] La couverture de code est maintenue (>90%)

### 4. Documentation
- [ ] Le code est documenté (docstrings, comments)
- [ ] La documentation est à jour
- [ ] Les changements sont documentés dans CHANGELOG.md

### 5. Sécurité
- [ ] Les inputs utilisateur sont validés
- [ ] Aucune injection possible (SQL, XSS, etc.)
- [ ] Les secrets ne sont pas exposés
- [ ] Les permissions sont vérifiées

### 6. Performance
- [ ] Le code est performant
- [ ] Pas de requêtes N+1
- [ ] Pas d'opérations coûteuses inutiles
- [ ] Les optimisations sont justifiées

### 7. Compatibilité
- [ ] Compatible avec les versions supportées
- [ ] Pas de breaking changes (ou documentés)
- [ ] Migration path fourni si nécessaire

### 8. Conventions
- [ ] Suit les conventions du projet
- [ ] Formatage cohérent (linting)
- [ ] Structure de fichiers respectée
- [ ] Naming conventions suivies

## 🔍 Points Spécifiques par Type

### Boutons / Interfaces
- [ ] Accessibilité (ARIA, keyboard navigation)
- [ ] Responsive design
- [ ] États de chargement/erreur

### APIs / Endpoints
- [ ] Validation des inputs
- [ ] Gestion d'erreurs appropriée
- [ ] Codes HTTP corrects
- [ ] Rate limiting considéré

### Base de Données
- [ ] Requêtes optimisées
- [ ] Index appropriés
- [ ] Pas de data leaks
- [ ] Migrations correctes

### Scripts / CLI
- [ ] Gestion d'erreurs
- [ ] Messages utilisateur clairs
- [ ] Validation des arguments
- [ ] Documentation --help

## 🚫 Anti-Patterns à Éviter

- ❌ Code mort (commented-out code)
- ❌ Magic numbers (utiliser des constantes)
- ❌ Noms génériques (var1, temp, data)
- ❌ Fonctions trop longues (>100 lignes)
- ❌ Duplication de code
- ❌ Hardcoded values
- ❌ Nested callbacks trop profondes
- ❌ Ignorer les erreurs silencieusement

## ✅ Bonnes Pratiques à Vérifier

- ✅ Single Responsibility Principle
- ✅ DRY (Don't Repeat Yourself)
- ✅ KISS (Keep It Simple, Stupid)
- ✅ Type hints / TypeScript types
- ✅ Error handling explicite
- ✅ Logging approprié
- ✅ Tests avant optimisation

## 📝 Format de Commentaire pour Reviewer

### Commentaires Constructifs
- **Suggestion**: "Pourrait-on améliorer X en faisant Y?"
- **Question**: "Pourquoi ce choix plutôt que Z?"
- **Beau travail**: "J'aime cette approche de X!"

### Niveaux de Priorité
- 🔴 **Blocker**: Doit être corrigé avant merge
- 🟡 **Important**: Devrait être corrigé, mais pas blocker
- 💡 **Suggestion**: Amélioration optionnelle

## 🎯 Critères d'Approval

Une PR peut être approuvée si:
- ✅ Tous les tests passent
- ✅ Couverture >90% maintenue
- ✅ Pas de blockers identifiés
- ✅ Au moins 1 reviewer a approuvé
- ✅ Pas de conflits avec main

## 🔄 Processus de Revue

1. **Auteur**: Crée PR avec description complète
2. **Reviewer**: Vérifie selon cette checklist
3. **Discussion**: Échanges si nécessaire
4. **Corrections**: Auteur corrige si besoin
5. **Approval**: Reviewer approuve
6. **Merge**: Merge après approval

## 📚 Ressources

- [Google Code Review Guide](https://google.github.io/eng-practices/review/)
- [Best Practices Code Review](https://github.com/google/eng-practices)
