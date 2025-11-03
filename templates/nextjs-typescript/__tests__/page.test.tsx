/**
 * Unit tests for Next.js page component
 */
import { describe, it, expect } from '@jest/globals';
import { render, screen } from '@testing-library/react';
import Home from '../src/app/page';

// Mock Next.js
jest.mock('next/navigation', () => ({
    useRouter: () => ({
        push: jest.fn(),
        replace: jest.fn(),
    }),
}));

describe('Home Page', () => {
    it('should render welcome message', () => {
        render(<Home />);
        const heading = screen.getByText(/Welcome to/i);
        expect(heading).toBeDefined();
    });

    it('should render project name placeholder', () => {
        render(<Home />);
        const text = screen.getByText(/__PROJECT_NAME__/);
        expect(text).toBeDefined();
    });

    it('should render Next.js description', () => {
        render(<Home />);
        const description = screen.getByText(/Built with Next.js/i);
        expect(description).toBeDefined();
    });

    it('should have correct structure', () => {
        const { container } = render(<Home />);
        const main = container.querySelector('main');
        expect(main).toBeDefined();
    });

    it('should have correct CSS classes', () => {
        const { container } = render(<Home />);
        const main = container.querySelector('main');
        expect(main?.className).toContain('flex');
        expect(main?.className).toContain('min-h-screen');
    });
});
