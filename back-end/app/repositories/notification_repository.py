"""
Notification repository - data access layer
"""
from sqlalchemy.orm import Session
from typing import List, Optional
from app.models.notification import Notification


class NotificationRepository:
    """Notification repository for database operations"""

    def __init__(self, db: Session):
        self.db = db

    def get_by_id(self, notification_id: str) -> Optional[Notification]:
        """Get a notification by ID"""
        return self.db.query(Notification).filter(Notification.id == notification_id).first()

    def get_all_by_user_id(self, user_id: str) -> List[Notification]:
        """Get all notifications for a specific user"""
        return (
            self.db.query(Notification)
            .filter(Notification.user_id == user_id)
            .order_by(Notification.created_at.desc())
            .all()
        )

    def create(self, user_id: str, title: str, content: str) -> Notification:
        """Create a notification for a user"""
        db_notification = Notification(
            user_id=user_id,
            title=title,
            content=content,
            is_read=False
        )
        self.db.add(db_notification)
        self.db.commit()
        self.db.refresh(db_notification)
        return db_notification

    def update_read_status(self, notification: Notification, is_read: bool) -> Notification:
        """Update read status of a notification"""
        notification.is_read = is_read
        self.db.commit()
        self.db.refresh(notification)
        return notification

    def delete(self, notification: Notification) -> bool:
        """Delete a notification"""
        self.db.delete(notification)
        self.db.commit()
        return True
