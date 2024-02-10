# routes/__init__.py
from .users import user_routes
from .calendar import calendar_routes
from .customers import customer_routes

__all__ = ['user_routes', 'calendar_routes', 'customer_routes']
