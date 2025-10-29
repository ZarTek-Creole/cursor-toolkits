"""
Items API Endpoints
"""
from typing import List
from fastapi import APIRouter, Depends, HTTPException

from src.app.core.database import get_db
from sqlalchemy.ext.asyncio import AsyncSession

router = APIRouter()


@router.get("/")
async def list_items(db: AsyncSession = Depends(get_db)):
    """List all items"""
    # TODO: Implement actual database query
    return {"items": []}


@router.get("/{item_id}")
async def get_item(item_id: int, db: AsyncSession = Depends(get_db)):
    """Get item by ID"""
    # TODO: Implement actual database query
    return {"id": item_id, "name": "Example Item"}


@router.post("/")
async def create_item(db: AsyncSession = Depends(get_db)):
    """Create new item"""
    # TODO: Implement actual creation logic
    return {"id": 1, "message": "Item created"}

