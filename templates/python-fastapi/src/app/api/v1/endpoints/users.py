"""
Users API Endpoints
"""
from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from src.app.core.database import get_db

router = APIRouter()


@router.get("/")
async def list_users(db: AsyncSession = Depends(get_db)):
    """List all users"""
    # TODO: Implement actual database query
    return {"users": []}

