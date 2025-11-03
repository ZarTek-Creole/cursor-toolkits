# ADR-005: Stratégie CI/CD

**Date**: 2025-01-28  
**Statut**: Accepté  
**Décideurs**: Équipe Cursor Toolkits

## Contexte

Nous devions définir une stratégie CI/CD pour automatiser les tests, la validation et les déploiements.

## Décision

Utiliser GitHub Actions avec:

1. **Workflows de Test**
   - Tests sur chaque PR
   - Tests sur push vers main
   - Tests hebdomadaires

2. **Workflows de Validation**
   - Validation des règles Cursor
   - Validation des configurations MCP
   - Vérification des tokens

3. **Workflows de Sécurité**
   - Audit des dépendances (hebdomadaire)
   - Scan de secrets
   - Tests de sécurité

4. **Workflows de Couverture**
   - Rapport de couverture
   - Upload vers Codecov
   - Seuils de couverture

5. **Workflows de Release**
   - Création automatique de tags
   - Génération de changelog
   - Publication npm (si applicable)

## Justification

1. **Automatisation**: Réduit les erreurs humaines
2. **Feedback rapide**: Détecte les problèmes tôt
3. **Sécurité**: Audit régulier des dépendances
4. **Qualité**: Couverture et validation automatiques

## Conséquences

### Positives

- ✅ Qualité garantie automatiquement
- ✅ Sécurité améliorée
- ✅ Releases fiables
- ✅ Feedback rapide aux contributeurs

### Négatives

- ⚠️ Coût GitHub Actions (gratuit pour open source)
- ⚠️ Maintenance des workflows
- ⚠️ Temps de CI peut être long

## Alternatives Considérées

### Alternative 1: CI manuel
- **Rejeté**: Trop d'erreurs, trop lent

### Alternative 2: Autres plateformes (GitLab CI, Jenkins)
- **Rejeté**: GitHub Actions intégré avec GitHub

## Workflows Créés

1. `tests.yml`: Tests unitaires et d'intégration
2. `security-audit.yml`: Audit de sécurité hebdomadaire
3. `coverage.yml`: Rapports de couverture
4. `test-all.yml`: Tests pour tous les templates

## Références

- GitHub Actions Documentation
- Best Practices CI/CD
- Codecov Integration
