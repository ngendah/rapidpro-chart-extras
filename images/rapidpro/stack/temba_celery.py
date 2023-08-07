import os

from django.conf import settings

import celery

# set the default Django settings module for the 'celery' program.
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "temba.settings")

if os.environ.get("CELERY_REDIS_SCHEDULER_URL"):
    redis_url = os.environ.get("CELERY_REDIS_SCHEDULER_URL")
    app = celery.Celery("temba", backend=redis_url, broker=redis_url)
    app.conf.update(CELERY_REDIS_SCHEDULER_URL=redis_url)
else:
    app = celery.Celery("temba")

app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks(lambda: settings.INSTALLED_APPS)
app.autodiscover_tasks(
    (
        "temba.channels.types.jiochat",
        "temba.channels.types.twitter",
        "temba.channels.types.wechat",
        "temba.channels.types.whatsapp",
    )
)
