import { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-100">
      <h1 className="text-4xl font-bold mb-4">Welcome to __PROJECT_NAME__</h1>
      <p className="text-lg mb-8">Built with React 18 + Vite + TypeScript</p>
      
      <div className="bg-white p-8 rounded-lg shadow-lg">
        <button
          onClick={() => setCount((count) => count + 1)}
          className="px-6 py-3 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition"
        >
          Count is {count}
        </button>
      </div>
    </div>
  )
}

export default App
