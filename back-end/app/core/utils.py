"""
Shared utility helpers
"""
import uuid


def generate_uuid() -> str:
    """Generate a new random UUID4 as a string.

    Used as the default value for all primary key columns so that every
    record gets a unique, application-generated string ID instead of
    relying on database autoincrement integers.
    """
    return str(uuid.uuid4())
