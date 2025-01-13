from celery import Celery

app = Celery("habit_tracker", broker="redis://localhost:6379/0")

app.conf.beat_schedule = {
    "send_reminders": {
        "task": "send_reminders_task",
        "schedule": 60.0,
    },
}
