from sqlalchemy import create_engine, inspect
from app.core.config import settings

engine = create_engine(settings.DATABASE_URL)
inspector = inspect(engine)
print('profiles columns:')
for col in inspector.get_columns('profiles'):
    print(col['name'], col['type'])
