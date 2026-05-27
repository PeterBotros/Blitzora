from sqlalchemy import create_engine, inspect

try:
    from app.core.config import settings
    
    engine = create_engine(settings.DATABASE_URL)
    inspector = inspect(engine)
    
    print("Columns in users table:")
    columns = inspector.get_columns('users')
    if columns:
        for col in columns:
            print(f"  {col['name']}: {col['type']}")
    else:
        print("  No columns found - table may not exist")
        
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
