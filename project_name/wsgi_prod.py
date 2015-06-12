import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "{{ project_name }}.settings")
application = get_wsgi_application()

try:
    import newrelic.agent
    this_dir = os.path.dirname(os.path.realpath(__file__))
    newrelic.agent.initialize(os.path.join(this_dir, 'newrelic.ini'))
    application = newrelic.agent.wsgi_application()(application)
except ImportError:
    pass
