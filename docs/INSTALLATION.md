# Installation Guide

Guide d'installation de cursor-toolkits pour Debian 12, macOS et Windows/WSL.

## Prérequis

- **Cursor IDE** >= 1.7.0
- **Git** installé
- **Python** >= 3.11 (pour templates Python)
- **Node.js** >= 18 (pour CLI npm)
- **PHP** >= 8.3 (pour templates Symfony)

## Installation

### Option 1 : Clone du repository

```bash
git clone <repository-url>
cd cursor-toolkits
make install
```

### Option 2 : Installation globale via npm

```bash
npm install -g cursor-toolkits
```

## Vérification

```bash
cursor-init --version
```

## Uninstallation

```bash
npm uninstall -g cursor-toolkits
```

