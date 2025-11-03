"""
Test configuration module
"""
import pytest
from pydantic import ValidationError
from src.app.core.config import Settings


def test_settings_default_values():
    """Test default settings values"""
    settings = Settings()
    assert settings.PROJECT_NAME == "__PROJECT_NAME__"
    assert settings.VERSION == "0.1.0"
    assert settings.DEBUG is False
    assert settings.API_V1_PREFIX == "/api/v1"
    assert isinstance(settings.ALLOWED_ORIGINS, list)
    assert "http://localhost:3000" in settings.ALLOWED_ORIGINS


def test_settings_from_env(monkeypatch):
    """Test settings loaded from environment variables"""
    monkeypatch.setenv("PROJECT_NAME", "test-project")
    monkeypatch.setenv("DEBUG", "true")
    monkeypatch.setenv("VERSION", "1.0.0")
    
    settings = Settings()
    assert settings.PROJECT_NAME == "test-project"
    assert settings.VERSION == "1.0.0"
    assert settings.DEBUG is True


def test_settings_database_url():
    """Test database URL setting"""
    settings = Settings()
    assert "postgresql+asyncpg://" in settings.DATABASE_URL


def test_settings_security():
    """Test security settings"""
    settings = Settings()
    assert settings.SECRET_KEY is not None
    assert isinstance(settings.ACCESS_TOKEN_EXPIRE_MINUTES, int)
    assert settings.ACCESS_TOKEN_EXPIRE_MINUTES > 0


def test_settings_redis():
    """Test Redis URL setting"""
    settings = Settings()
    assert "redis://" in settings.REDIS_URL


def test_settings_config_class():
    """Test Settings Config class"""
    settings = Settings()
    assert hasattr(settings.Config, 'env_file')
    assert settings.Config.env_file == ".env"
    assert settings.Config.case_sensitive is True
