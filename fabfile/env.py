from fabric.api import env
from os.path import expanduser

env.key_filename = (expanduser(''),)
env.user = 'datadesk'
env.known_hosts = ''
env.chef = '/usr/local/bin/chef-solo -c solo.rb -j node.json'
env.app_user = 'datadesk'
env.project_dir = ''
env.activate = 'source <PATH TO VENV>/bin/activate'
env.branch = 'master'
env.AWS_SECRET_ACCESS_KEY = ''
env.AWS_ACCESS_KEY_ID = ''
env.hosts = ("",)
