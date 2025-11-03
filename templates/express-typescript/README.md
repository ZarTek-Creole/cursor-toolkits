# __PROJECT_NAME__

Production-ready Express.js API with TypeScript, Prisma, and comprehensive testing.

## Features

- 🚀 **Express.js** - Fast, unopinionated web framework
- 📘 **TypeScript** - Type-safe development
- 🗄️ **Prisma** - Next-generation ORM
- 🧪 **Jest** - Testing framework
- 🔒 **Helmet** - Security middleware
- 🐳 **Docker** - Containerization ready

## Getting Started

### Install Dependencies

```bash
npm install
```

### Setup Database

```bash
# Generate Prisma Client
npm run prisma:generate

# Run migrations
npm run prisma:migrate
```

### Development

```bash
npm run dev
```

Server runs on [http://localhost:3000](http://localhost:3000)

### Build

```bash
npm run build
npm start
```

### Test

```bash
npm test
```

## Project Structure

```
src/
├── routes/        # API routes
├── controllers/   # Route controllers
├── services/      # Business logic
├── middleware/    # Express middleware
├── utils/         # Utility functions
└── types/         # TypeScript types
```

## Cursor IDE

This project includes optimized Cursor rules for:
- Express.js patterns
- TypeScript best practices
- Prisma database operations
- Testing with Jest

## License

MIT
