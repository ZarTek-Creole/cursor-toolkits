"""
Users API Endpoints
"""
from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.database import get_db
from src.app.models.user import User

router = APIRouter()


@router.get("/")
async def list_users(db: AsyncSession = Depends(get_db)) -> dict:
    """List all users"""
    result = await db.execute(select(User))
    users = result.scalars().all()
    return {
        "users": [
            {
                "id": user.id,
                "email": user.email,
                "username": user.username,
                "full_name": user.full_name,
                "is_active": user.is_active,
                "created_at": user.created_at.isoformat() if user.created_at else None,
            }
            for user in users
        ]
    }

