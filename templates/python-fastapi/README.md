# __PROJECT_NAME__

FastAPI application with async SQLAlchemy 2.0, Pydantic 2, and PostgreSQL.

## Features

- ⚡ **Async-first** architecture
- 🔒 **Pydantic 2** for validation
- 🗄️ **SQLAlchemy 2.0** with async support
- 🐳 **Docker** & Docker Compose
- 🧪 **pytest** with async support
- 📚 **Auto-generated docs** (Swagger/ReDoc)

## Quick Start

### Development

```bash
# Install dependencies
poetry install

# Copy environment file
cp .env.example .env

# Run with Docker Compose
docker-compose up -d

# Run locally
poetry run uvicorn src.app.main:app --reload
```

### Testing

```bash
# Run tests
poetry run pytest

# Run with coverage
poetry run pytest --cov=src
```

## Project Structure

```
src/app/
├── api/v1/        # API routes
├── core/          # Configuration
├── models/        # SQLAlchemy models
├── schemas/       # Pydantic schemas
└── services/      # Business logic
```

## API Documentation

Once running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Environment Variables

See `.env.example` for all required variables.

## License

MIT

