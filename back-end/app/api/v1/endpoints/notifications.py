"""
Notification endpoints
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.notification import NotificationResponse, NotificationCreate
from app.services.notification_service import NotificationService
from app.core.exceptions import (
    NotFoundError,
    not_found_exception,
)

router = APIRouter()


@router.get("/", response_model=List[NotificationResponse])
async def get_notifications(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Retrieve all notifications for the authenticated user"""
    service = NotificationService(db)
    return service.get_my_notifications(current_user.id)


@router.post("/", response_model=NotificationResponse, status_code=status.HTTP_201_CREATED)
async def push_notification(
    data: NotificationCreate,
    db: Session = Depends(get_db)
):
    """Push a notification to a specific user_id (system utility endpoint)"""
    service = NotificationService(db)
    return service.create_notification(data.user_id, data.title, data.content)


@router.put("/{notification_id}/read", response_model=NotificationResponse)
async def mark_notification_as_read(
    notification_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Mark a notification as read (i.e. read it)"""
    service = NotificationService(db)
    try:
        return service.mark_as_read(current_user.id, notification_id)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.delete("/{notification_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_notification(
    notification_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Delete a specific notification"""
    service = NotificationService(db)
    try:
        service.delete_notification(current_user.id, notification_id)
        return None
    except NotFoundError as e:
        raise not_found_exception(str(e))
