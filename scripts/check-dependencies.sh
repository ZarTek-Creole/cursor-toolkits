#!/bin/bash
# Script to check for outdated dependencies across all technologies

set -e

echo "🔍 Vérification des dépendances..."

# Node.js (root)
echo ""
echo "📦 Node.js (root)"
if command -v npm &> /dev/null; then
    npm outdated || echo "  ✅ Toutes dépendances à jour"
else
    echo "  ⚠️ npm non disponible"
fi

# Python (root)
echo ""
echo "🐍 Python (root)"
if command -v pip &> /dev/null; then
    pip list --outdated 2>/dev/null | head -10 || echo "  ✅ Toutes dépendances à jour"
else
    echo "  ⚠️ pip non available"
fi

# Templates Node.js
echo ""
echo "📦 Templates Node.js"
for template in templates/*-typescript templates/*-vite templates/nestjs templates/express-typescript templates/react-vite templates/vue3 templates/t3-stack; do
    if [ -f "$template/package.json" ]; then
        echo "  Checking $(basename $template)..."
        cd "$template" && npm outdated 2>/dev/null | head -5 || echo "    ✅ À jour" && cd - > /dev/null
    fi
done

# Templates Python
echo ""
echo "🐍 Templates Python"
for template in templates/python-fastapi templates/django-api; do
    if [ -f "$template/pyproject.toml" ] || [ -f "$template/requirements.txt" ]; then
        echo "  Checking $(basename $template)..."
        # Note: Requires virtualenv for accurate check
        echo "    ⚠️ Vérification manuelle recommandée"
    fi
done

# Templates PHP
echo ""
echo "🐘 Templates PHP"
for template in templates/symfony-api templates/slim-api; do
    if [ -f "$template/composer.json" ]; then
        echo "  Checking $(basename $template)..."
        cd "$template" && composer outdated 2>/dev/null | head -5 || echo "    ✅ À jour" && cd - > /dev/null
    fi
done

echo ""
echo "✅ Vérification terminée"
