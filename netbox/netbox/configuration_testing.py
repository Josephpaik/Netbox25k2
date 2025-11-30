###################################################################
#  This file serves as a base configuration for testing purposes  #
#  only. It is not intended for production use.                   #
###################################################################

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

SECRET_KEY = 
'OWb_bqU0HQ35QFbM4cP-&y^A0rzoD9dRdkAu410Fc@IHJTJ+YvYZ0123456789'
 
DEFAULT_PERMISSIONS = {}

ALLOW_TOKEN_RETRIEVAL = True

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True
}

DEBUG = True

TIME_ZONE = 'Asia/Seoul'
