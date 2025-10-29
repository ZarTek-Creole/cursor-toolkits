#!/usr/bin/env node

/**
 * Cursor Toolkits - NPM Wrapper for cursor-init CLI
 * Bridge between npm and bash script
 */

import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { spawn } from 'child_process';
import { existsSync } from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const BASH_SCRIPT = join(__dirname, 'cursor-init');

// Check if bash script exists
if (!existsSync(BASH_SCRIPT)) {
    console.error('Error: cursor-init bash script not found');
    process.exit(1);
}

// Get command line arguments
const args = process.argv.slice(2);

// Spawn bash script with arguments
const child = spawn(BASH_SCRIPT, args, {
    stdio: 'inherit',
    shell: false
});

// Handle exit
child.on('exit', (code) => {
    process.exit(code || 0);
});

child.on('error', (error) => {
    console.error('Error executing cursor-init:', error.message);
    process.exit(1);
});
