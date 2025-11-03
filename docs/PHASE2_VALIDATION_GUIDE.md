# Phase 2 Validation Guide - Guide d'exécution

**Objectif**: Valider Phase 2 avec résultats réels et documentation

---

## 🎯 ÉTAPES VALIDATION

### 1. Recette Utilisateur Réelle

#### A. Préparation

```bash
# Assurer que tous les scripts sont exécutables
chmod +x tests/user_acceptance/test_scenarios.sh
chmod +x tests/performance/benchmark_real_projects.sh
chmod +x tests/security/security_scan_complete.sh

# Vérifier CLI fonctionne
cd /workspace
make install
cursor-init --help
```

#### B. Exécution Tests Automatisés

```bash
# Exécuter scénarios automatisés
bash tests/user_acceptance/test_scenarios.sh > tests/user_acceptance/results.log 2>&1
```

#### C. Tests Utilisateur Réels (Optionnel mais recommandé)

**Identifier 2-3 utilisateurs test**:
1. Utilisateurs avec expérience Cursor IDE
2. Utilisateurs sans expérience (nouveaux utilisateurs)
3. Développeurs différentes stack (Python, Node.js, PHP)

**Scénarios à tester**:
1. Installation depuis source
2. Création projet Python FastAPI
3. Création projet Next.js
4. Création projet Symfony
5. Utilisation prompts/commandes générés
6. Feedback UX (facilité, clarté)

**Documenter feedback**:
- Créer fichier `tests/user_acceptance/feedback.md`
- Noter problèmes rencontrés
- Noter suggestions amélioration

---

### 2. Performances Réelles

#### A. Exécution Benchmarks

```bash
# Exécuter benchmarks
bash tests/performance/benchmark_real_projects.sh

# Résultats dans CSV
cat /tmp/cursor-toolkits-benchmark-*/results.csv
```

#### B. Analyse Résultats

**Vérifier seuils**:
- ✓ Bon: < 5s génération
- ⚠ Acceptable: < 10s
- ✗ À optimiser: > 10s

**Documenter**:
- Créer `docs/PERFORMANCE_RESULTS.md`
- Inclure métriques par template
- Identifier templates lents (>10s)

#### C. Optimisations Si Nécessaire

Si templates >10s:
1. Analyser pourquoi (nombre fichiers, complexité)
2. Optimiser génération si possible
3. Documenter dans rapport

---

### 3. Sécurité Complète

#### A. Installation Outils

```bash
# Python Safety
pip install safety

# Gitleaks (voir https://github.com/gitleaks/gitleaks)
# Pour Linux:
wget https://github.com/gitleaks/gitleaks/releases/download/v8.18.0/gitleaks_8.18.0_linux_x64.tar.gz
tar -xzf gitleaks_8.18.0_linux_x64.tar.gz
sudo mv gitleaks /usr/local/bin/

# Composer (si templates PHP)
# Voir documentation PHP
```

#### B. Exécution Scan Complet

```bash
# Avec Safety API key (optionnel mais recommandé)
export SAFETY_API_KEY="your-key"
bash tests/security/security_scan_complete.sh > tests/security/results.log 2>&1

# Sans API key (fonctionne mais limité)
bash tests/security/security_scan_complete.sh > tests/security/results.log 2>&1
```

#### C. Analyse Résultats

**Vérifier**:
- ✅ npm: 0 vulnérabilités
- ⚠️ Python: Analyser résultat safety
- ⚠️ Composer: Analyser résultat (si applicable)
- ⚠️ Secrets: Vérifier gitleaks n'a rien détecté

**Documenter**:
- Créer `docs/SECURITY_AUDIT_RESULTS.md`
- Noter vulnérabilités trouvées
- Plan de correction si nécessaire

---

### 4. Revues Code Systématiques

#### A. Configuration GitHub

1. **Branch Protection Rules**:
   - Suivre `.github/branch-protection-template.md`
   - Configurer rules pour `main`

2. **CODEOWNERS**:
   - Éditer `.github/CODEOWNERS`
   - Remplacer `@cursor-toolkits/*` par vrais usernames
   - Exemple:
     ```
     /lib/ @votre-username
     ```

3. **Teams** (optionnel):
   - Créer teams GitHub si organisation
   - Utiliser dans CODEOWNERS

#### B. Test avec PR

1. Créer branche test
2. Faire changement mineur
3. Créer PR
4. Vérifier:
   - ✅ Reviewers assignés automatiquement
   - ✅ Status checks s'exécutent
   - ✅ PR template vérifié
   - ✅ Coverage check pass

#### C. Documentation Process

- Documenter process dans `docs/CODE_REVIEW_PROCESS.md`
- Noter feedback équipe
- Ajuster si nécessaire

---

## 📊 RAPPORT FINAL PHASE 2

### Template Rapport

Créer `docs/PHASE2_VALIDATION_RESULTS.md`:

```markdown
# Phase 2 Validation Results

**Date**: [DATE]
**Exécuté par**: [NAME]

## 1. Recette Utilisateur

### Tests Automatisés
- Résultat: ✅/❌
- Détails: [copier résultats]

### Tests Utilisateurs Réels
- Utilisateurs: [NOMBRE]
- Feedback: [résumé]
- Problèmes: [liste]
- Suggestions: [liste]

## 2. Performances

### Benchmarks
| Template | Temps (s) | Statut |
|----------|-----------|--------|
| python-fastapi | X.X | ✓/⚠/✗ |
| nextjs-typescript | X.X | ✓/⚠/✗ |

### Analyse
- Templates <5s: [liste]
- Templates 5-10s: [liste]
- Templates >10s: [liste]
- Optimisations nécessaires: [liste]

## 3. Sécurité

### npm Audit
- Vulnérabilités: 0
- Statut: ✅

### Python Safety
- Vulnérabilités: [X]
- Statut: ✅/⚠/❌
- Détails: [copier résultats]

### Composer Audit
- Vulnérabilités: [X]
- Statut: ✅/⚠/❌

### Secret Scanning
- Secrets trouvés: [X]
- Statut: ✅/❌

## 4. Revues Code

### Configuration
- Branch protection: ✅/❌
- CODEOWNERS: ✅/❌
- Workflow: ✅/❌

### Test PR
- Reviewers assignés: ✅/❌
- Status checks: ✅/❌
- Process fonctionnel: ✅/❌

## Conclusion

**Phase 2**: ✅ Validée / ⚠️ Partielle / ❌ Non validée

**Prochaines étapes**: [liste]
```

---

## ✅ CRITÈRES VALIDATION PHASE 2

### Production Complet Validé quand:

1. ✅ Recette utilisateur:
   - Tests automatisés passent
   - 2-3 utilisateurs réels testés (optionnel mais recommandé)
   - Feedback intégré si nécessaire

2. ✅ Performances:
   - Benchmarks exécutés
   - Résultats documentés
   - Templates <10s (ou optimisations planifiées)

3. ✅ Sécurité:
   - npm: 0 vulnérabilités
   - Python safety exécuté
   - Secret scanning exécuté
   - Vulnérabilités corrigées si trouvées

4. ✅ Revues Code:
   - Branch protection configurée
   - CODEOWNERS configuré
   - Workflow testé avec PR réelle

---

## 🚀 COMMANDES RAPIDES

```bash
# Tout exécuter en une fois
cd /workspace
make install
bash tests/user_acceptance/test_scenarios.sh
bash tests/performance/benchmark_real_projects.sh
bash tests/security/security_scan_complete.sh

# Vérifier résultats
find /tmp -name "cursor-toolkits-*" -type d
```

---

**Ce guide permet de valider Phase 2 complètement avec résultats réels.**
