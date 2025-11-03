# ADR-002: Système de Prompts et Commandes

**Date**: 2025-01-28  
**Statut**: Accepté  
**Décideurs**: Équipe Cursor Toolkits

## Contexte

Les utilisateurs de Cursor IDE bénéficient de prompts prédéfinis et de commandes personnalisées. Nous devions décider comment intégrer cela dans nos templates.

## Décision

Nous avons créé un système centralisé avec:

1. **Base de données centralisée**: `lib/prompts/prompts.json` et `lib/commands/commands.json`
2. **Génération automatique**: Script Python qui génère les fichiers `.cursor/` pour chaque template
3. **Format standard**: JSON conforme à la spécification Cursor IDE

## Justification

1. **DRY**: Évite la duplication entre templates similaires
2. **Maintenabilité**: Une seule source de vérité
3. **Cohérence**: Format identique pour tous les templates
4. **Évolutivité**: Facile d'ajouter de nouveaux prompts/commandes

## Conséquences

### Positives

- ✅ Maintenance simplifiée
- ✅ Cohérence garantie
- ✅ Génération automatique
- ✅ Intégration native Cursor IDE

### Négatives

- ⚠️ Nécessite un script de génération
- ⚠️ Dépendance Python pour la génération

## Alternatives Considérées

### Alternative 1: Fichiers individuels par template
- **Rejeté**: Duplication, maintenance difficile

### Alternative 2: Génération manuelle
- **Rejeté**: Erreurs humaines, incohérences

## Références

- [Cursor Commands Documentation](https://cursor.com/docs/agent/chat/commands)
- [Cursor Commands Examples](https://github.com/hamzafer/cursor-commands)
