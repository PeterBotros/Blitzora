"""
Reminder repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import Optional, List
from app.models.reminder import Reminder
from app.schemas.reminder import ReminderCreate


class ReminderRepository:
    """Reminder repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, reminder_id: str) -> Optional[Reminder]:
        """Get reminder by ID"""
        return self.db.query(Reminder).filter(Reminder.id == reminder_id).first()

    def get_user_reminder(self, reminder_id: str, user_id: str) -> Optional[Reminder]:
        """Get a reminder that belongs to a specific user"""
        return (
            self.db.query(Reminder)
            .filter(Reminder.id == reminder_id, Reminder.user_id == user_id)
            .first()
        )

    def get_all_by_user_id(self, user_id: str) -> List[Reminder]:
        """Get all reminders for a user ordered by creation time"""
        return (
            self.db.query(Reminder)
            .filter(Reminder.user_id == user_id)
            .order_by(Reminder.created_at.asc())
            .all()
        )

    def create(self, user_id: str, data: ReminderCreate) -> Reminder:
        """Create a new reminder for the user"""
        db_reminder = Reminder(
            user_id=user_id,
            name=data.name,
            dosage=data.dosage,
            time=data.time,
            icon_type=data.icon_type,
            is_taken=data.is_taken,
        )
        self.db.add(db_reminder)
        self.db.commit()
        self.db.refresh(db_reminder)
        return db_reminder

    def update(self, reminder: Reminder, update_data: dict) -> Reminder:
        """Update reminder fields"""
        for field, value in update_data.items():
            setattr(reminder, field, value)
        self.db.commit()
        self.db.refresh(reminder)
        return reminder

    def delete(self, reminder: Reminder) -> bool:
        """Delete a reminder"""
        self.db.delete(reminder)
        self.db.commit()
        return True

    def reset_all_taken(self, user_id: str) -> int:
        """Reset is_taken to False for all user reminders (daily reset)"""
        count = (
            self.db.query(Reminder)
            .filter(Reminder.user_id == user_id, Reminder.is_taken == True)
            .update({"is_taken": False})
        )
        self.db.commit()
        return count
