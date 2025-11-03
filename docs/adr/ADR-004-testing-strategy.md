# ADR-004: Stratégie de Tests

**Date**: 2025-01-28  
**Statut**: Accepté  
**Décideurs**: Équipe Cursor Toolkits

## Contexte

Nous devions définir une stratégie de tests complète pour garantir la qualité et la maintenabilité du projet.

## Décision

Adopter une stratégie de tests en pyramide avec:

1. **Tests Unitaires** (base): >90% couverture
   - Tests isolés des fonctions/modules
   - Tests rapides (<1s par test)
   - Mock des dépendances externes

2. **Tests d'Intégration** (milieu)
   - Tests des composants ensemble
   - Tests de génération de projets
   - Tests de validation

3. **Tests de Performance** (sommet)
   - Benchmarks de génération
   - Tests de charge (si applicable)
   - Seuils de performance définis

4. **Tests de Sécurité**
   - Validation des inputs
   - Détection de secrets
   - Audit des dépendances

## Justification

1. **Couverture élevée**: Garantit que le code fonctionne
2. **Pyramide**: Plus de tests unitaires (rapides) que d'intégration (lents)
3. **Performance**: Garantit que le projet reste rapide
4. **Sécurité**: Essentiel pour un outil utilisé par beaucoup

## Conséquences

### Positives

- ✅ Qualité de code garantie
- ✅ Régressions détectées rapidement
- ✅ Confiance dans les releases
- ✅ Documentation via les tests

### Négatives

- ⚠️ Temps de développement augmenté
- ⚠️ Maintenance des tests nécessaire
- ⚠️ CI/CD plus long

## Alternatives Considérées

### Alternative 1: Tests manuels uniquement
- **Rejeté**: Trop lent, erreurs humaines

### Alternative 2: Tests E2E uniquement
- **Rejeté**: Trop lent, difficile à debugger

## Métriques

- **Couverture minimale**: 90%
- **Temps max tests unitaires**: <30s total
- **Temps max génération projet**: <5s
- **Temps max génération règles**: <3s

## Références

- Testing Pyramid (Martin Fowler)
- Google Testing Blog
- pytest, Jest documentation
