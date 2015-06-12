from setuptools import setup
from distutils.core import Command


class TestCommand(Command):
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        from django.conf import settings
        settings.configure(
            DATABASES={
                'default': {
                    'NAME': ':memory:',
                    'ENGINE': 'django.db.backends.sqlite3'
                }
            },
            INSTALLED_APPS=(
                'django.contrib.auth',
                'django.contrib.contenttypes',
                'django.contrib.sessions',
                'django.contrib.admin',
                'toolbox',
            )
        )
        # In Django > 1.7 you have to run setup to get app registry in order
        import django
        if django.VERSION[:2] >= (1, 7):
            django.setup()
        # With Django 1.6, the way tests were discovered changed (see
        # https://docs.djangoproject.com/en/1.7/releases/1.6/#new-test-runner)
        # Set the argument to the test management command appropriately
        # depending on the Django version
        test_module = 'toolbox.tests'
        if django.VERSION[:2] < (1, 6):
            test_module = 'toolbox'
        from django.core.management import call_command
        call_command('test', test_module)


setup(
    name='django-project-template',
    cmdclass={'test': TestCommand}
)
