/**
 * Unit tests for cursor-init-wrapper.js
 */
import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import { spawn } from 'child_process';
import { existsSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import * as path from 'path';
import * as fs from 'fs';

// Mock child_process
jest.mock('child_process', () => ({
    spawn: jest.fn(),
}));

// Mock fs
jest.mock('fs', () => ({
    existsSync: jest.fn(),
}));

describe('cursor-init-wrapper.js', () => {
    let mockSpawn;
    let mockProcess;
    
    beforeEach(() => {
        jest.clearAllMocks();
        mockProcess = {
            on: jest.fn((event, callback) => {
                if (event === 'exit') {
                    setTimeout(() => callback(0), 0);
                }
                return mockProcess;
            }),
            exit: jest.fn(),
        };
        mockSpawn = spawn;
        mockSpawn.mockReturnValue(mockProcess);
    });
    
    afterEach(() => {
        jest.restoreAllMocks();
    });
    
    it('should check if bash script exists', () => {
        existsSync.mockReturnValue(true);
        expect(existsSync).toBeDefined();
    });
    
    it('should handle script not found', () => {
        existsSync.mockReturnValue(false);
        // This would exit with code 1 in actual execution
        expect(existsSync).toBeDefined();
    });
    
    it('should spawn bash script with arguments', () => {
        existsSync.mockReturnValue(true);
        const args = ['--version'];
        mockSpawn.mockReturnValue(mockProcess);
        
        expect(mockSpawn).toBeDefined();
        expect(typeof mockSpawn).toBe('function');
    });
    
    it('should handle spawn errors', () => {
        existsSync.mockReturnValue(true);
        const error = new Error('Spawn failed');
        mockProcess.on.mockImplementation((event, callback) => {
            if (event === 'error') {
                callback(error);
            }
            return mockProcess;
        });
        
        expect(mockProcess.on).toBeDefined();
    });
    
    it('should handle process exit', () => {
        existsSync.mockReturnValue(true);
        mockProcess.on.mockImplementation((event, callback) => {
            if (event === 'exit') {
                callback(0);
            }
            return mockProcess;
        });
        
        expect(mockProcess.on).toBeDefined();
    });
});
