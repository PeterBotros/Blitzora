"""
Reminder service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import List
from app.repositories.reminder_repository import ReminderRepository
from app.schemas.reminder import ReminderCreate, ReminderUpdate, ReminderResponse
from app.core.exceptions import NotFoundError


class ReminderService:
    """Reminder service for business logic"""

    def __init__(self, db: Session):
        self.repository = ReminderRepository(db)

    def get_all_user_reminders(self, user_id: str) -> List[ReminderResponse]:
        """Get all reminders for the authenticated user"""
        reminders = self.repository.get_all_by_user_id(user_id)
        return [ReminderResponse.model_validate(r) for r in reminders]

    def create_reminder(self, user_id: str, data: ReminderCreate) -> ReminderResponse:
        """Create a new medication reminder"""
        reminder = self.repository.create(user_id, data)
        return ReminderResponse.model_validate(reminder)

    def update_reminder(self, reminder_id: str, user_id: str, data: ReminderUpdate) -> ReminderResponse:
        """Update an existing reminder (ownership validated)"""
        reminder = self.repository.get_user_reminder(reminder_id, user_id)
        if not reminder:
            raise NotFoundError(f"Reminder with ID {reminder_id} not found")
        update_dict = data.model_dump(exclude_unset=True)
        updated = self.repository.update(reminder, update_dict)
        return ReminderResponse.model_validate(updated)

    def delete_reminder(self, reminder_id: str, user_id: str) -> bool:
        """Delete a reminder (ownership validated)"""
        reminder = self.repository.get_user_reminder(reminder_id, user_id)
        if not reminder:
            raise NotFoundError(f"Reminder with ID {reminder_id} not found")
        return self.repository.delete(reminder)

    def reset_daily_taken(self, user_id: str) -> int:
        """Reset all is_taken flags to False for a new day"""
        return self.repository.reset_all_taken(user_id)
