# ADR-003: Stubs Fonctionnels dans les Templates

**Date**: 2025-01-28  
**Statut**: Accepté  
**Décideurs**: Équipe Cursor Toolkits

## Contexte

Les templates doivent contenir du code fonctionnel, pas seulement des TODOs. Cependant, ils doivent rester des exemples et non des implémentations complètes.

## Décision

Utiliser des **stubs fonctionnels** qui:
1. Implémentent la logique de base (requêtes DB, modèles)
2. Restent simples et éducatifs
3. Documentent clairement qu'ils sont des exemples
4. Fournissent une base solide pour développement

## Justification

1. **Utilisabilité**: Les templates doivent fonctionner immédiatement
2. **Pédagogie**: Montrent les bonnes pratiques
3. **Tests**: Permettent de tester la structure complète
4. **Évolution**: Base solide pour développement ultérieur

## Conséquences

### Positives

- ✅ Templates fonctionnels dès la création
- ✅ Modèles et schémas complets
- ✅ Tests peuvent être écrits immédiatement
- ✅ Meilleure expérience utilisateur

### Négatives

- ⚠️ Plus de code à maintenir
- ⚠️ Risque que les utilisateurs copient sans comprendre

## Alternatives Considérées

### Alternative 1: TODOs uniquement
- **Rejeté**: Trop frustrant pour les utilisateurs

### Alternative 2: Implémentations complètes
- **Rejeté**: Trop complexe, limite la flexibilité

## Références

- Bonnes pratiques FastAPI
- Doctrine ORM Symfony
