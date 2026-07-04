"""
Reminder endpoints - GET, POST, PUT, DELETE
"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from typing import List

from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.user import User
from app.schemas.reminder import ReminderCreate, ReminderUpdate, ReminderResponse
from app.services.reminder_service import ReminderService
from app.core.exceptions import NotFoundError, not_found_exception

router = APIRouter()


@router.get("/", response_model=List[ReminderResponse])
async def get_reminders(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Retrieve all medication reminders for the authenticated user"""
    service = ReminderService(db)
    return service.get_all_user_reminders(current_user.id)


@router.post("/", response_model=ReminderResponse, status_code=status.HTTP_201_CREATED)
async def create_reminder(
    reminder_data: ReminderCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Create a new medication reminder for the authenticated user"""
    service = ReminderService(db)
    return service.create_reminder(current_user.id, reminder_data)


@router.put("/{reminder_id}", response_model=ReminderResponse)
async def update_reminder(
    reminder_id: str,
    update_data: ReminderUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Update a reminder's details or mark it as taken/not-taken"""
    service = ReminderService(db)
    try:
        return service.update_reminder(reminder_id, current_user.id, update_data)
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.delete("/{reminder_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_reminder(
    reminder_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Delete a medication reminder"""
    service = ReminderService(db)
    try:
        service.delete_reminder(reminder_id, current_user.id)
        return None
    except NotFoundError as e:
        raise not_found_exception(str(e))


@router.post("/reset-daily", status_code=status.HTTP_200_OK)
async def reset_daily_taken(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Reset all reminders' is_taken flag to False (call at start of a new day)"""
    service = ReminderService(db)
    count = service.reset_daily_taken(current_user.id)
    return {"message": f"Reset {count} reminders for today"}
