# ADR-001: Structure des Templates

**Date**: 2025-01-28  
**Statut**: Accepté  
**Décideurs**: Équipe Cursor Toolkits

## Contexte

Nous devions définir une structure standardisée pour tous les templates afin de garantir la cohérence, la maintenabilité et la facilité d'utilisation.

## Décision

Nous avons adopté une structure modulaire avec les composants suivants:

```
template-name/
├── template.json          # Métadonnées du template
├── README.md             # Documentation spécifique
├── .cursor/
│   ├── prompts.json      # Prompts prédéfinis
│   ├── commands.json     # Commandes personnalisées
│   ├── rules/            # Règles Cursor (.mdc)
│   └── .mcp.json.example # Configuration MCP
└── [code source]         # Code spécifique au template
```

## Justification

1. **Cohérence**: Structure identique pour tous les templates
2. **Découvrabilité**: `.cursor/` permet à Cursor IDE de détecter automatiquement
3. **Modularité**: Séparation claire entre règles, prompts, commandes
4. **Maintenabilité**: Facile à mettre à jour et étendre

## Conséquences

### Positives

- ✅ Structure prévisible pour les utilisateurs
- ✅ Génération automatique facilitée
- ✅ Intégration native avec Cursor IDE
- ✅ Facile à documenter

### Négatives

- ⚠️ Nécessite de créer plusieurs fichiers par template
- ⚠️ Structure plus complexe qu'un simple dossier de code

## Alternatives Considérées

### Alternative 1: Structure plate
- **Rejeté**: Trop simple, manque d'organisation

### Alternative 2: Structure par type
- **Rejeté**: Trop complexe, difficile à maintenir

## Références

- [Cursor IDE Documentation](https://cursor.com/docs)
- [MCP Specification](https://modelcontextprotocol.io)
