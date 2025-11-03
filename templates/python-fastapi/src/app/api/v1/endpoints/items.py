"""
Items API Endpoints
"""
from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.database import get_db
from src.app.models.item import Item

router = APIRouter()


@router.get("/")
async def list_items(db: AsyncSession = Depends(get_db)) -> dict:
    """List all items"""
    result = await db.execute(select(Item))
    items = result.scalars().all()
    return {
        "items": [
            {
                "id": item.id,
                "name": item.name,
                "description": item.description,
                "created_at": item.created_at.isoformat() if item.created_at else None,
            }
            for item in items
        ]
    }


@router.get("/{item_id}")
async def get_item(item_id: int, db: AsyncSession = Depends(get_db)) -> dict:
    """Get item by ID"""
    result = await db.execute(select(Item).where(Item.id == item_id))
    item = result.scalar_one_or_none()
    
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    
    return {
        "id": item.id,
        "name": item.name,
        "description": item.description,
        "created_at": item.created_at.isoformat() if item.created_at else None,
        "updated_at": item.updated_at.isoformat() if item.updated_at else None,
    }


@router.post("/")
async def create_item(
    name: str,
    description: str | None = None,
    db: AsyncSession = Depends(get_db)
) -> dict:
    """Create new item"""
    new_item = Item(name=name, description=description)
    db.add(new_item)
    await db.commit()
    await db.refresh(new_item)
    
    return {
        "id": new_item.id,
        "name": new_item.name,
        "description": new_item.description,
        "message": "Item created successfully",
    }

