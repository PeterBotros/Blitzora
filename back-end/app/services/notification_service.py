"""
Notification service - business logic layer
"""
from sqlalchemy.orm import Session
from typing import List
from app.repositories.notification_repository import NotificationRepository
from app.schemas.notification import NotificationResponse
from app.core.exceptions import NotFoundError


class NotificationService:
    """Notification service for business logic"""

    def __init__(self, db: Session):
        self.repository = NotificationRepository(db)

    def get_my_notifications(self, user_id: str) -> List[NotificationResponse]:
        """Get all notifications for the authenticated user"""
        notifications = self.repository.get_all_by_user_id(user_id)
        return [NotificationResponse.model_validate(n) for n in notifications]

    def create_notification(self, user_id: str, title: str, content: str) -> NotificationResponse:
        """Create and push a new notification"""
        notification = self.repository.create(user_id, title, content)
        return NotificationResponse.model_validate(notification)

    def mark_as_read(self, user_id: str, notification_id: str) -> NotificationResponse:
        """Mark a notification as read after validating ownership"""
        notification = self.repository.get_by_id(notification_id)
        if not notification or notification.user_id != user_id:
            raise NotFoundError(f"Notification with ID {notification_id} not found")
        updated = self.repository.update_read_status(notification, True)
        return NotificationResponse.model_validate(updated)

    def delete_notification(self, user_id: str, notification_id: str) -> bool:
        """Delete a notification after validating ownership"""
        notification = self.repository.get_by_id(notification_id)
        if not notification or notification.user_id != user_id:
            raise NotFoundError(f"Notification with ID {notification_id} not found")
        return self.repository.delete(notification)
