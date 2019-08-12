from flask_restplus import Namespace, Resource, fields

api = Namespace('iso', description='iso images')

iso = api.model('ISO', {
    'id': fields.String(required=True, description='id'),
    'name': fields.String(required=True, description='name')
    })

ISO = [
    {'id': 'centos', 'name': 'Centos7'},
    {'id': 'rhel', 'name': 'RHEL7'}
]

@api.route('/')
class ISOList(Resource):
    @api.doc('list_iso')
    @api.marshal_list_with(iso)
    def get(self):
        '''List all iso'''
        return ISO

@api.route('/<id>')
@api.param('id', 'The iso identifier')
@api.response(404, 'ISO not found')
class Iso(Resource):
    @api.doc('get_iso')
    @api.marshal_with(iso)
    def get(self, id):
        '''Fetch an iso'''
        for i in ISO:
            if i['id'] == id:
                return i
        api.abort(404)
