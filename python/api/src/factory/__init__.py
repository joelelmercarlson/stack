from flask_restplus import Api

from .iso import api as iso_api
from .image import api as image_api

api = Api(
    title='imageFactory API',
    version='1.0',
    description='A simple demo API')

api.add_namespace(iso_api)
api.add_namespace(image_api)
