from b2handle.handleclient import EUDATHandleClient
from b2handle.clientcredentials import PIDClientCredentials
import b2handle.handleexceptions
import uuid
import sys
import json
import os

def get_handle():
    dirname = os.path.dirname(__file__)
    filename = os.path.join(dirname, '../hdl_cred.json')
    cred = PIDClientCredentials.load_from_JSON(filename)
    try:
      client = EUDATHandleClient.instantiate_with_credentials(cred)
      new_handle= client.generate_and_register_handle("21.12134", "https://google.com")
      print(new_handle)
      print(client.retrieve_handle_record_json(new_handle))
      return new_handle
    except b2handle.handleexceptions.HandleAuthenticationError:
      return -1

def delete_handle(new_handle):
    dirname = os.path.dirname(__file__)
    filename = os.path.join(dirname, '../hdl_cred.json')
    cred = PIDClientCredentials.load_from_JSON(filename)
    client = EUDATHandleClient.instantiate_with_credentials(cred)
    try:
      client.delete_handle(new_handle)
      return True
    except b2handle.handleexceptions.HandleNotFoundException:
      return False
