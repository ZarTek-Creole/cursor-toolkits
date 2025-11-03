"""
Test API router configuration
"""
import pytest
from fastapi import APIRouter
from src.app.api.v1.api import api_router


def test_api_router_instance():
    """Test API router is instance of APIRouter"""
    assert isinstance(api_router, APIRouter)


def test_api_router_routes():
    """Test API router has routes"""
    assert len(api_router.routes) > 0


def test_api_router_includes_items():
    """Test items router is included"""
    routes = [route.path for route in api_router.routes]
    assert any("/items" in route.path for route in api_router.routes)


def test_api_router_includes_users():
    """Test users router is included"""
    routes = [route.path for route in api_router.routes]
    assert any("/users" in route.path for route in api_router.routes)
