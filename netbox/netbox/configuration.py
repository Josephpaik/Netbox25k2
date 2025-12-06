
##############################################
#  This file serves as a base configuration  #
#  It is intended for production use.        #
##############################################

ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'NAME': 'netbox',
        'USER': 'netbox',
        'PASSWORD': 'netbox1234!', 
        'HOST': '127.0.0.1',
        'PORT': '5432',
        'CONN_MAX_AGE': 300,
    }
}

PLUGINS = [
    'netbox.tests.dummy_plugin',
]

REDIS = {
    'tasks': {
        'HOST': 'localhost',
        'PORT': 6379,
        'USERNAME': '',
        'PASSWORD': '',
        'DATABASE': 0,
        'SSL': False,
    },
    'caching': {
        'HOST': 'localhost',
        'PORT': 6379,
        'USERNAME': '',
        'PASSWORD': '',
        'DATABASE': 1,
        'SSL': False,
    }
}

SECRET_KEY = '=&qK!UbZiy@TjK^Y^STWsJyKAB3ucg#j-v^uZFx#cJ+I1EAqj_'
DEFAULT_PERMISSIONS = {}
ALLOW_TOKEN_RETRIEVAL = True
LOGGING = {
    'version': 1,
    'disable_existing_loggers': True
}
DEBUG = True
TIME_ZONE = 'Asia/Seoul'
