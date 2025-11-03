# Bash Script Template

Template production-ready pour scripts Bash avec gestion d'erreurs, logging, et tests.

## Caractéristiques

- ✅ Gestion d'erreurs robuste (`set -euo pipefail`)
- ✅ Logging coloré et structuré
- ✅ Fonctions modulaires
- ✅ Tests avec BATS
- ✅ Documentation inline
- ✅ Support des options CLI

## Structure

```
.
├── bin/              # Scripts exécutables
├── lib/              # Fonctions réutilisables
├── tests/            # Tests BATS
├── scripts/          # Scripts utilitaires
└── README.md
```

## Utilisation

```bash
# Exécuter un script
./bin/main.sh

# Exécuter les tests
bats tests/
```

## Best Practices

- Toujours utiliser `set -euo pipefail`
- Valider les inputs
- Utiliser des fonctions pour la modularité
- Logger toutes les actions importantes
- Gérer les erreurs proprement
