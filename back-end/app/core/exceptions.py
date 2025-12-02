"""
Custom exception classes
"""
from fastapi import HTTPException, status


class AppException(Exception):
    """Base application exception"""
    pass


class NotFoundError(AppException):
    """Resource not found exception"""
    pass


class ValidationError(AppException):
    """Validation error exception"""
    pass


class AuthenticationError(AppException):
    """Authentication error exception"""
    pass


class AuthorizationError(AppException):
    """Authorization error exception"""
    pass


def not_found_exception(message: str = "Resource not found"):
    """Return 404 HTTP exception"""
    return HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=message
    )


def validation_exception(message: str = "Validation error"):
    """Return 422 HTTP exception"""
    return HTTPException(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        detail=message
    )


def authentication_exception(message: str = "Could not validate credentials"):
    """Return 401 HTTP exception"""
    return HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail=message,
        headers={"WWW-Authenticate": "Bearer"},
    )


def authorization_exception(message: str = "Not enough permissions"):
    """Return 403 HTTP exception"""
    return HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail=message
    )

