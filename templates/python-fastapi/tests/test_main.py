"""
Test main endpoints
"""
import pytest
from httpx import AsyncClient
from fastapi import FastAPI
from src.app.main import app, create_app


@pytest.mark.asyncio
async def test_health_check(client: AsyncClient):
    """Test health check endpoint"""
    response = await client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "version" in data
    assert data["version"] == "0.1.0"


@pytest.mark.asyncio
async def test_health_check_structure(client: AsyncClient):
    """Test health check response structure"""
    response = await client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, dict)
    assert "status" in data
    assert "version" in data


@pytest.mark.asyncio
async def test_list_items(client: AsyncClient):
    """Test list items endpoint"""
    response = await client.get("/api/v1/items/")
    assert response.status_code == 200
    data = response.json()
    assert "items" in data
    assert isinstance(data["items"], list)


@pytest.mark.asyncio
async def test_get_item(client: AsyncClient):
    """Test get item by ID endpoint"""
    item_id = 1
    response = await client.get(f"/api/v1/items/{item_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == item_id
    assert "name" in data


@pytest.mark.asyncio
async def test_get_item_invalid_id(client: AsyncClient):
    """Test get item with invalid ID format"""
    # Test with non-numeric ID
    response = await client.get("/api/v1/items/abc")
    assert response.status_code == 422  # Validation error


@pytest.mark.asyncio
async def test_create_item(client: AsyncClient):
    """Test create item endpoint"""
    response = await client.post("/api/v1/items/")
    assert response.status_code == 200
    data = response.json()
    assert "id" in data
    assert "message" in data
    assert data["message"] == "Item created"


@pytest.mark.asyncio
async def test_list_users(client: AsyncClient):
    """Test list users endpoint"""
    response = await client.get("/api/v1/users/")
    assert response.status_code == 200
    data = response.json()
    assert "users" in data
    assert isinstance(data["users"], list)


@pytest.mark.asyncio
async def test_cors_headers(client: AsyncClient):
    """Test CORS headers are present"""
    response = await client.options("/health")
    # Options request should be handled by CORS middleware
    assert response.status_code in [200, 204, 405]


def test_create_app():
    """Test create_app function"""
    test_app = create_app()
    assert isinstance(test_app, FastAPI)
    assert test_app.title == "__PROJECT_NAME__"
    assert test_app.version == "0.1.0"


def test_app_instance():
    """Test app instance"""
    assert app is not None
    assert isinstance(app, FastAPI)


def test_app_routes():
    """Test that routes are registered"""
    routes = [route.path for route in app.routes]
    assert "/health" in routes
    assert any("/api/v1" in route.path for route in app.routes)
