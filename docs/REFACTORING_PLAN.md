# 🔧 Plan de Refactorisation - cursor-init

**Date**: 2025-01-28  
**Objectif**: Réduire la complexité de `bin/cursor-init` de 519 lignes vers des modules séparés

## 📊 État Actuel

- **Lignes**: 519
- **Fonctions**: 10
- **Complexité**: Moyenne-Élevée
- **Maintenabilité**: ⚠️ À améliorer

## 🎯 Objectif

- **Lignes par fichier**: <200
- **Fonctions**: <15 par module
- **Complexité cyclomatique**: <10 par fonction

## 📦 Structure Proposée

### Avant (1 fichier)
```
bin/cursor-init (519 lignes)
  ├── show_banner()
  ├── usage()
  ├── list_templates()
  ├── show_template_info()
  ├── detect_stack()
  ├── interactive_mode()
  ├── validate_project_name()
  ├── create_project()
  ├── setup_mcp_servers()
  └── analyze_existing_project()
```

### Après (Modules séparés)
```
bin/
├── cursor-init (main, ~100 lignes)
├── lib/
│   ├── cli/
│   │   ├── banner.sh
│   │   ├── usage.sh
│   │   ├── interactive.sh
│   │   └── menu.sh
│   ├── validation/
│   │   └── validators.sh
│   ├── generation/
│   │   ├── templates.sh
│   │   ├── project.sh
│   │   └── mcp.sh
│   └── analysis/
│       └── detector.sh
```

## 🔨 Plan de Refactorisation

### Phase 1: Extraction Utilitaires (Non-Bloquant)

#### 1.1 Créer `lib/cli/banner.sh`
**Fonctions à extraire**:
- `show_banner()`
- `usage()`

**Taille estimée**: ~50 lignes

#### 1.2 Créer `lib/cli/interactive.sh`
**Fonctions à extraire**:
- `interactive_mode()`
- Menus interactifs

**Taille estimée**: ~150 lignes

#### 1.3 Créer `lib/validation/validators.sh`
**Fonctions à extraire**:
- `validate_project_name()`

**Taille estimée**: ~30 lignes

### Phase 2: Extraction Génération (Important)

#### 2.1 Créer `lib/generation/project.sh`
**Fonctions à extraire**:
- `create_project()`
- Logique de copie/remplacement

**Taille estimée**: ~150 lignes

#### 2.2 Créer `lib/generation/templates.sh`
**Fonctions à extraire**:
- `list_templates()`
- `show_template_info()`
- Gestion des templates

**Taille estimée**: ~100 lignes

#### 2.3 Créer `lib/generation/mcp.sh`
**Fonctions à extraire**:
- `setup_mcp_servers()`

**Taille estimée**: ~50 lignes

### Phase 3: Extraction Analyse (Futur)

#### 3.1 Créer `lib/analysis/detector.sh`
**Fonctions à extraire**:
- `detect_stack()`
- `analyze_existing_project()`

**Taille estimée**: ~100 lignes

## 📝 Exemple de Refactorisation

### Avant (cursor-init actuel)
```bash
show_banner() {
    cat << EOF
    ...
EOF
}

usage() {
    cat << EOF
    ...
EOF
}

# ... 500+ lignes supplémentaires
```

### Après (modulaire)

**bin/cursor-init** (main):
```bash
#!/bin/bash
set -e

# Source modules
source "$(dirname "$0")/../lib/cli/banner.sh"
source "$(dirname "$0")/../lib/cli/interactive.sh"
source "$(dirname "$0")/../lib/validation/validators.sh"
# ... autres imports

# Main logic
main() {
    show_banner
    
    if [ "$1" = "--interactive" ] || [ $# -eq 0 ]; then
        interactive_mode
    else
        # Handle command-line arguments
        # ...
    fi
}

main "$@"
```

**lib/cli/banner.sh**:
```bash
show_banner() {
    cat << EOF
    ...
EOF
}

usage() {
    cat << EOF
    ...
EOF
}
```

## ✅ Avantages

### Maintenabilité
- ✅ Fichiers plus petits et focalisés
- ✅ Facile de trouver la fonction recherchée
- ✅ Changements isolés

### Testabilité
- ✅ Tests unitaires par module
- ✅ Mocking plus simple
- ✅ Tests d'intégration séparés

### Réutilisabilité
- ✅ Modules réutilisables
- ✅ Réutilisation dans autres scripts

### Lisibilité
- ✅ Code organisé logiquement
- ✅ Noms de fichiers descriptifs

## ⚠️ Inconvénients

### Complexité Initiale
- ⚠️ Plus de fichiers à maintenir
- ⚠️ Gestion des imports

### Migration
- ⚠️ Refactorisation nécessite tests
- ⚠️ Risque de régression

## 📅 Timeline

### Option 1: Refactorisation Complète (Recommandée)
- **Phase 1**: 2-3 jours
- **Phase 2**: 2-3 jours
- **Phase 3**: 1-2 jours
- **Total**: 5-8 jours

### Option 2: Refactorisation Incrémentale
- Extraire 1-2 modules à la fois
- Tester après chaque extraction
- **Durée**: 2-3 semaines (moins de risques)

## 🧪 Tests Post-Refactorisation

1. **Tests de régression**:
   ```bash
   # Comparer comportement avant/après
   make test
   ```

2. **Tests d'intégration**:
   ```bash
   # Tester tous les scénarios
   tests/test-cli.sh
   ```

3. **Tests de performance**:
   ```bash
   # Tester que temps de génération inchangé
   tests/performance/test_generation_performance.py
   ```

## 🎯 Critères de Succès

### Métriques
- [ ] `cursor-init` <100 lignes
- [ ] Aucun module >200 lignes
- [ ] Tous les tests passent
- [ ] Performance inchangée
- [ ] Couverture >90% maintenue

### Qualité
- [ ] Code plus lisible
- [ ] Facile à étendre
- [ ] Documentation à jour

## 📚 Bonnes Pratiques

1. **Sourcing**: Utiliser `source` avec chemins absolus
2. **Variables**: Préfixer variables globales (`CLI_*`)
3. **Erreurs**: Gestion d'erreur cohérente
4. **Tests**: Tests avant refactorisation

## 🚀 Actions Immédiates

### Court Terme (Non-Bloquant)
- [ ] Créer structure de dossiers
- [ ] Extraire `banner.sh` et `usage.sh`
- [ ] Tester extraction

### Moyen Terme (Important)
- [ ] Extraire modules de génération
- [ ] Extraire modules de validation
- [ ] Refactoriser `cursor-init` main

### Long Terme (Amélioration)
- [ ] Extraire modules d'analyse
- [ ] Optimiser imports
- [ ] Documentation complète

## 📝 Notes

- **Priorité**: Moyenne (amélioration, pas blocker)
- **Risque**: Faible si fait incrémentalement
- **Bénéfice**: Maintenabilité améliorée à long terme
