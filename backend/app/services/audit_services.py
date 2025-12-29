from sqlalchemy.orm import Session
from app.models.audit_log import AuditLog
from typing import Any, Dict
import json

class AuditService:
    @staticmethod
    def log_action(
        db: Session,
        user_id: str,
        action: str,
        resource_type: str,
        resource_id: str,
        old_values: Dict[str, Any] = None,
        new_values: Dict[str, Any] = None
    ):
        audit_log = AuditLog(
            user_id=user_id,
            action=action,
            resource_type=resource_type,
            resource_id=resource_id,
            old_values=json.dumps(old_values) if old_values else None,
            new_values=json.dumps(new_values) if new_values else None
        )
        db.add(audit_log)
        db.commit()
