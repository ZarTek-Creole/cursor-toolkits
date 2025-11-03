"""
Test items endpoints
"""
import pytest
from httpx import AsyncClient
from fastapi import APIRouter
from src.app.api.v1.endpoints.items import router, list_items, get_item, create_item


def test_items_router_instance():
    """Test items router is APIRouter instance"""
    assert isinstance(router, APIRouter)


@pytest.mark.asyncio
async def test_list_items_function(client: AsyncClient):
    """Test list_items function directly"""
    from sqlalchemy.ext.asyncio import AsyncSession
    from unittest.mock import AsyncMock
    
    mock_db = AsyncMock(spec=AsyncSession)
    result = await list_items(db=mock_db)
    assert isinstance(result, dict)
    assert "items" in result
    assert isinstance(result["items"], list)


@pytest.mark.asyncio
async def test_get_item_function():
    """Test get_item function directly"""
    from sqlalchemy.ext.asyncio import AsyncSession
    from unittest.mock import AsyncMock
    
    mock_db = AsyncMock(spec=AsyncSession)
    result = await get_item(item_id=1, db=mock_db)
    assert isinstance(result, dict)
    assert result["id"] == 1
    assert "name" in result


@pytest.mark.asyncio
async def test_get_item_with_different_ids(client: AsyncClient):
    """Test get_item with different IDs"""
    for item_id in [1, 42, 999]:
        response = await client.get(f"/api/v1/items/{item_id}")
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == item_id


@pytest.mark.asyncio
async def test_create_item_function():
    """Test create_item function directly"""
    from sqlalchemy.ext.asyncio import AsyncSession
    from unittest.mock import AsyncMock
    
    mock_db = AsyncMock(spec=AsyncSession)
    result = await create_item(db=mock_db)
    assert isinstance(result, dict)
    assert "id" in result
    assert "message" in result
    assert result["message"] == "Item created"


@pytest.mark.asyncio
async def test_items_endpoint_methods(client: AsyncClient):
    """Test allowed HTTP methods for items endpoints"""
    # GET should work
    response = await client.get("/api/v1/items/")
    assert response.status_code == 200
    
    # POST should work
    response = await client.post("/api/v1/items/")
    assert response.status_code == 200
    
    # PUT should not work (not implemented)
    response = await client.put("/api/v1/items/1")
    assert response.status_code in [404, 405]


@pytest.mark.asyncio
async def test_get_item_with_zero_id(client: AsyncClient):
    """Test get_item with ID 0"""
    response = await client.get("/api/v1/items/0")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == 0


@pytest.mark.asyncio
async def test_get_item_with_negative_id(client: AsyncClient):
    """Test get_item with negative ID"""
    response = await client.get("/api/v1/items/-1")
    # Should still work (validation might not catch negative)
    assert response.status_code in [200, 422]
