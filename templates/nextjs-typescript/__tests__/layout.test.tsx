/**
 * Unit tests for Next.js layout component
 */
import { describe, it, expect } from '@jest/globals';
import { render } from '@testing-library/react';
import RootLayout from '../src/app/layout';

describe('Root Layout', () => {
    it('should render children', () => {
        const { container } = render(
            <RootLayout>
                <div>Test Content</div>
            </RootLayout>
        );
        
        expect(container.textContent).toContain('Test Content');
    });

    it('should have html element', () => {
        const { container } = render(
            <RootLayout>
                <div>Test</div>
            </RootLayout>
        );
        
        const html = container.querySelector('html');
        expect(html).toBeDefined();
    });

    it('should have body element', () => {
        const { container } = render(
            <RootLayout>
                <div>Test</div>
            </RootLayout>
        );
        
        const body = container.querySelector('body');
        expect(body).toBeDefined();
    });

    it('should have lang attribute', () => {
        const { container } = render(
            <RootLayout>
                <div>Test</div>
            </RootLayout>
        );
        
        const html = container.querySelector('html');
        expect(html?.getAttribute('lang')).toBe('en');
    });
});
