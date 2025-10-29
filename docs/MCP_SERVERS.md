# MCP Servers Integration

Guide pour intégrer les serveurs MCP (Model Context Protocol) avec Cursor IDE.

## Configuration

Chaque template inclut un fichier `.cursor/.mcp.json.example` à copier vers `.cursor/mcp.json`.

## Serveurs Recommandés

### GitHub MCP

- **Commande**: `npx -y @modelcontextprotocol/server-github`
- **Token requis**: GITHUB_TOKEN
- **Usage**: Gestion des issues, PRs, code search

### PostgreSQL MCP

- **Commande**: `npx -y @modelcontextprotocol/server-postgres`
- **Variables**: DATABASE_URL
- **Usage**: Query database, introspection schema

## Installation

```bash
# Copier et éditer la configuration
cp templates/python-fastapi/.cursor/.mcp.json.example .cursor/mcp.json

# Définir les variables d'environnement
export GITHUB_TOKEN="your-token"
```

## Variables d'environnement

Définir dans `.env` ou l'environnement système :

- `GITHUB_TOKEN` : Token GitHub (PAT)
- `DATABASE_URL` : Connection string PostgreSQL

