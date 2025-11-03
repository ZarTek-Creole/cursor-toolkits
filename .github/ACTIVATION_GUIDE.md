# Guide d'Activation GitHub - Revues Code Systématiques

**Objectif**: Activer complètement le système de revues de code dans GitHub

**Temps estimé**: 30 minutes

---

## ✅ ÉTAPES D'ACTIVATION

### 1. Configurer Branch Protection Rules (15min)

#### A. Accéder aux Settings
1. Aller sur votre repository GitHub
2. Cliquer sur **Settings**
3. Cliquer sur **Branches** dans le menu de gauche
4. Cliquer sur **Add rule** ou modifier la règle existante pour `main`/`master`

#### B. Configurer la Règle pour `main`

**Nom de branche**: `main` (ou `master`)

**Options à activer**:

```
✅ Require a pull request before merging
  ✅ Require approvals: 1
  ✅ Dismiss stale pull request approvals when new commits are pushed
  ✅ Require PR author to be approved by reviewers (optionnel)

✅ Require status checks to pass before merging
  ✅ Require branches to be up to date before merging
  ✅ Required status checks:
    - test (si workflow test-all.yml existe)
    - coverage (si workflow coverage.yml existe)
    - security-audit (si workflow security-audit.yml existe)
  
✅ Require conversation resolution before merging

✅ Require signed commits (optionnel mais recommandé pour sécurité)

✅ Do not allow bypassing the above settings (recommandé)
```

#### C. Configurer Règle pour `develop` (si applicable)

**Paramètres** (moins stricts pour faciliter développement):

```
✅ Require a pull request before merging
  ✅ Require approvals: 1
  
✅ Require status checks to pass before merging
  
⚠️ Pas de signature requise (pour vitesse dev)
```

---

### 2. Configurer CODEOWNERS (10min)

#### A. Éditer CODEOWNERS

Le fichier `.github/CODEOWNERS` existe déjà. Éditer:

```bash
# Remplacer les placeholders par vrais usernames GitHub
nano .github/CODEOWNERS
```

#### B. Exemple de Configuration

**Option 1: Individuels**
```
# Core Infrastructure
/bin/                   @username-maintainer
/lib/                   @username-maintainer
/tests/                 @username-maintainer @username-tester

# Templates
/templates/             @username-maintainer @username-templates

# Documentation
/docs/                  @username-maintainer @username-docs
/README.md              @username-maintainer
```

**Option 2: Teams GitHub** (si organisation)
```
# Core Infrastructure
/bin/                   @your-org/maintainers
/lib/                   @your-org/maintainers
/tests/                 @your-org/maintainers @your-org/testers

# Templates
/templates/             @your-org/maintainers @your-org/templates-team

# Documentation
/docs/                  @your-org/maintainers @your-org/docs-team
```

#### C. Créer Teams (si organisation)

1. Aller sur **Settings** → **Teams**
2. Créer teams:
   - `maintainers` (core contributors)
   - `templates-team` (specialistes templates)
   - `docs-team` (documentation)
   - `testers` (QA)
3. Ajouter membres aux teams

---

### 3. Tester le Système (5min)

#### A. Créer Branche Test

```bash
git checkout -b test/review-process
echo "# Test PR" >> test_review.md
git add test_review.md
git commit -m "Test: Review process"
git push origin test/review-process
```

#### B. Créer Pull Request

1. Aller sur GitHub
2. Cliquer **Pull Requests** → **New Pull Request**
3. Base: `main`, Compare: `test/review-process`
4. Remplir template PR
5. Créer PR

#### C. Vérifier

✅ **Reviewers assignés automatiquement** (selon CODEOWNERS)  
✅ **Status checks s'exécutent** (workflows GitHub Actions)  
✅ **PR template vérifié**  
✅ **Coverage check pass**  

#### D. Approuver et Merger

1. Reviewer approuve la PR
2. Status checks passent
3. Merger la PR

---

## 📋 CHECKLIST ACTIVATION COMPLÈTE

- [ ] Branch protection rules configurées pour `main`
- [ ] Status checks ajoutés (test, coverage, security)
- [ ] CODEOWNERS édité avec vrais usernames
- [ ] Teams créés (si organisation)
- [ ] Workflow `.github/workflows/code-review.yml` présent
- [ ] Test avec PR réelle effectué
- [ ] Process fonctionnel validé

---

## 🔍 VÉRIFICATION POST-ACTIVATION

### Vérifier Branch Protection

```bash
# Via GitHub CLI (si installé)
gh api repos/:owner/:repo/branches/main/protection

# Ou vérifier manuellement dans GitHub Settings → Branches
```

### Vérifier CODEOWNERS

```bash
# Vérifier syntaxe
cat .github/CODEOWNERS

# Tester avec gh CLI (si installé)
gh api repos/:owner/:repo/contents/.github/CODEOWNERS
```

### Vérifier Workflow

```bash
# Voir workflows
ls -la .github/workflows/

# Vérifier dernière exécution dans GitHub Actions
```

---

## 🎯 RÉSULTAT ATTENDU

Après activation complète:

1. ✅ Toutes les PRs nécessitent approbation
2. ✅ Reviewers assignés automatiquement selon CODEOWNERS
3. ✅ Status checks s'exécutent automatiquement
4. ✅ Couverture code vérifiée
5. ✅ Sécurité vérifiée
6. ✅ Process documenté et fonctionnel

---

## 📚 RESSOURCES

- [GitHub Branch Protection Docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
- [CODEOWNERS Documentation](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Required Status Checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches#require-status-checks-before-merging)

---

## 🆘 DÉPANNAGE

### Reviewers non assignés automatiquement

- Vérifier syntaxe CODEOWNERS (sensible à majuscules/minuscules)
- Vérifier que usernames existent dans GitHub
- Vérifier permissions repository

### Status checks ne passent pas

- Vérifier workflows dans `.github/workflows/`
- Vérifier noms exacts des workflows
- Vérifier que workflows sont activés dans repository

### Branch protection ne s'applique pas

- Vérifier nom de branche exact (`main` vs `master`)
- Vérifier permissions administrateur
- Vérifier que règle est sauvegardée

---

**Temps total**: ~30 minutes  
**Difficulté**: Facile  
**Impact**: Haut (améliore qualité code significativement)
