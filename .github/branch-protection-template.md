# Branch Protection Rules Configuration Guide

## 🔒 Configuration Branch Protection Rules

Pour activer les revues de code systématiques, configurer les branch protection rules dans GitHub:

### 1. Accéder aux Settings du Repository

```
Settings → Branches → Branch protection rules → Add rule
```

### 2. Règle pour `main`/`master`

**Nom de branche**: `main` ou `master`

**Paramètres recommandés**:
```
✅ Require a pull request before merging
  ✅ Require approvals: 1
  ✅ Dismiss stale pull request approvals when new commits are pushed
  
✅ Require status checks to pass before merging
  ✅ Require branches to be up to date before merging
  ✅ Status checks: 
    - test (from test-all.yml)
    - coverage (from coverage.yml)
    - security-audit (from security-audit.yml)
  
✅ Require conversation resolution before merging

✅ Require signed commits (optionnel mais recommandé)

✅ Require linear history (optionnel)
```

### 3. Règle pour `develop` (si applicable)

**Nom de branche**: `develop`

**Paramètres**:
```
✅ Require a pull request before merging
  ✅ Require approvals: 1
  
✅ Require status checks to pass before merging
  ✅ Require branches to be up to date before merging
  
⚠️ Moins strict que main pour faciliter développement
```

### 4. Configuration CODEOWNERS

Le fichier `.github/CODEOWNERS` est déjà créé. Pour l'activer:

1. **Identifier les reviewers**:
   - Remplacer `@cursor-toolkits/maintainers` par vrais usernames GitHub
   - Exemple: `/lib/ @username1 @username2`

2. **Activation automatique**:
   - GitHub utilise automatiquement CODEOWNERS
   - Les reviewers sont assignés automatiquement aux PRs

### 5. Teams GitHub (Optionnel mais recommandé)

Pour utiliser des teams:

1. Créer teams dans GitHub:
   - `@your-org/maintainers`
   - `@your-org/templates-team`
   - `@your-org/docs-team`

2. Ajouter membres aux teams

3. Utiliser dans CODEOWNERS:
   ```
   /lib/ @your-org/maintainers
   ```

---

## 📋 Checklist Activation

- [ ] Branch protection rules configurées pour `main`
- [ ] Status checks configurés (test, coverage, security)
- [ ] CODEOWNERS configuré avec vrais reviewers
- [ ] Teams créés (si applicable)
- [ ] Workflow `.github/workflows/code-review.yml` activé
- [ ] Test avec une PR réelle

---

## 🔗 Références

- [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
- [CODEOWNERS Documentation](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Required Status Checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-status-checks-before-merging)

---

**Note**: Ces configurations nécessitent des droits administrateur sur le repository.
