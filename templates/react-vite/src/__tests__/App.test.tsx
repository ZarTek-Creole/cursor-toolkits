import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import App from '../App'

describe('App', () => {
  it('renders welcome message', () => {
    render(<App />)
    const heading = screen.getByText(/Welcome to/i)
    expect(heading).toBeDefined()
  })

  it('renders project name', () => {
    render(<App />)
    const text = screen.getByText(/__PROJECT_NAME__/i)
    expect(text).toBeDefined()
  })
})
