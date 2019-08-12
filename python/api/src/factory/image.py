from flask_restplus import Namespace, Resource, fields

api = Namespace('image', description='machine images')

image = api.model('IMAGE', {
    'id': fields.String(required=True, description='id'),
    'name': fields.String(required=True, description='name')
    })

IMAGE = [
    {'id': 'centos', 'name': 'Centos7 VM'},
    {'id': 'rhel', 'name': 'RHEL7 VM'}
]

@api.route('/')
class IMAGEList(Resource):
    @api.doc('list_image')
    @api.marshal_list_with(image)
    def get(self):
        '''List all image'''
        return IMAGE

@api.route('/<id>')
@api.param('id', 'The image identifier')
@api.response(404, 'IMAGE not found')
class Image(Resource):
    @api.doc('get_image')
    @api.marshal_with(image)
    def get(self, id):
        '''Fetch an image'''
        for i in IMAGE:
            if i['id'] == id:
                return i
        api.abort(404)
