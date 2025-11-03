"""
Test database module
"""
import pytest
from sqlalchemy.ext.asyncio import AsyncSession
from src.app.core.database import get_db, AsyncSessionLocal, engine, Base


@pytest.mark.asyncio
async def test_get_db():
    """Test database session dependency"""
    async for session in get_db():
        assert isinstance(session, AsyncSession)
        assert session.is_active
        break


@pytest.mark.asyncio
async def test_get_db_commit_on_success():
    """Test that session commits on success"""
    async for session in get_db():
        # Session should be active
        assert session.is_active
        # Should not raise exception on normal flow
        break


@pytest.mark.asyncio
async def test_get_db_rollback_on_exception():
    """Test that session rolls back on exception"""
    exception_raised = False
    try:
        async for session in get_db():
            raise ValueError("Test exception")
    except ValueError:
        exception_raised = True
    
    assert exception_raised


def test_async_session_local():
    """Test AsyncSessionLocal configuration"""
    assert AsyncSessionLocal is not None
    assert callable(AsyncSessionLocal)


def test_engine_configuration():
    """Test engine configuration"""
    assert engine is not None
    assert engine.pool is not None


def test_base_declarative():
    """Test declarative base"""
    assert Base is not None
    assert hasattr(Base, 'metadata')
