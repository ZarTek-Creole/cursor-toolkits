"""
Test users endpoints
"""
import pytest
from httpx import AsyncClient
from fastapi import APIRouter
from src.app.api.v1.endpoints.users import router, list_users


def test_users_router_instance():
    """Test users router is APIRouter instance"""
    assert isinstance(router, APIRouter)


@pytest.mark.asyncio
async def test_list_users_function():
    """Test list_users function directly"""
    from sqlalchemy.ext.asyncio import AsyncSession
    from unittest.mock import AsyncMock
    
    mock_db = AsyncMock(spec=AsyncSession)
    result = await list_users(db=mock_db)
    assert isinstance(result, dict)
    assert "users" in result
    assert isinstance(result["users"], list)


@pytest.mark.asyncio
async def test_users_endpoint_methods(client: AsyncClient):
    """Test allowed HTTP methods for users endpoints"""
    # GET should work
    response = await client.get("/api/v1/users/")
    assert response.status_code == 200
    
    # POST should not work (not implemented)
    response = await client.post("/api/v1/users/")
    assert response.status_code in [404, 405]
