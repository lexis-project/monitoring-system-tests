from keycloak import KeycloakOpenID
from irods.session import iRODSSession
import requests
import sys
import shutil
import json
import jwt
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)


def get_irods_home(irods_dic):
    return '/' + '/'.join([irods_dic['zone'], 'home', irods_dic['user']])

def get_irods_federated_home(irods_dic, federated_dic):
    return '/' + '/'.join([federated_dic['federated_zone'], '{}#{}'.format(irods_dic['user'],federated_dic['federated_zone'])])

def get_token_keycloak(keycloak_input):
    print(keycloak_input)
    keycloak_openid = KeycloakOpenID(server_url=keycloak_input['host'],
                                     client_id=keycloak_input['client_id'],
                                     realm_name=keycloak_input['realm_name'],
                                     client_secret_key=keycloak_input['client_secret_key'])
    # Get Token
    token = keycloak_openid.token(keycloak_input['user'], keycloak_input['pass'])
    return token

def get_token_broker(url, key, subject):
    print(url)
    print(key)
    print(subject)
    r = requests.get("{}/token".format(url),
                     headers={'Authorization': "Basic {}".format(key)},
                     params={'provider': 'keycloak_openid', 'uid': subject, 'scope': 'openid'}, verify=True)
    return json.loads(r.content)


def parse_token(token):
    logger.info(token)	
    return jwt.decode(token['access_token'].encode('utf-8'), options={"verify_signature": False},  algorithms=["RS256", "HS256"])

def validate_token_keycloak(keycloak_input, token):
    keycloak_openid = KeycloakOpenID(server_url=keycloak_input['host'],
                                     client_id=keycloak_input['client_id'],
                                     realm_name=keycloak_input['realm_name'],
                                     client_secret_key=keycloak_input['client_secret_key'])
    # Introspect Token
    return keycloak_openid.introspect(token['access_token'])

def validate_token_broker(irods_dic, token):
    r = requests.get(irods_dic['openid_microservice'] + '/validate_token',
                        params={'provider': 'keycloak_openid', 'access_token': token['access_token']}, verify=True)
    return json.loads(r.content)

def get_irods_session(irods_dic, host, token=''):
    return iRODSSession(host=host, port=irods_dic['port'],
                           password=irods_dic['pass'], user=irods_dic['user'],
                            zone=irods_dic['zone'],
                            token=token,
                            block_on_authURL=False)

def get_session_federated_zone(token, irods_dic, number, machines):
    #user = get_user(token)
    host = irods_dic.get('federated_host')
    session = iRODSSession(host= host, port=irods_dic.get('federated_port'), authentication_scheme='openid',
         openid_provider='keycloak_openid',
        zone=irods_dic.get('federated_zone'), access_token=token, user=irods_dic.get('federated_user'),
        block_on_authURL=False)
    return session

def irods_ls(session, source_path):
    objects = session.collections.get(source_path).data_objects
    return [str(o) for o in objects]

def irods_put_object(session, src, dest):
    """ Puts src file in iRODS """
    chunk_size = 2 * (1024 ** 2)
    obj = session.data_objects.create(dest, force=True)
    with obj.open('r+') as f_out, open(src, 'rb') as f_in:
        while True:
            chunk = f_in.read(chunk_size)
            if len(chunk) <= 0:
                break
            f_out.write(chunk)

def irods_read_object(session, src):
    """ Reads file from iRODS """
    obj = session.data_objects.get(src)
    lines = []
    with obj.open('r+') as f:
        for line in f:
            lines.append(line.decode('UTF-8'))
    return lines

def irods_delete_object(session, src):
    """ Delete data object from iRODS at src path"""
    session.data_objects.unlink(src)
