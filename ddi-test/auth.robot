*** Settings ***
Library	    lib/ddi-l1.py
Library	    lib/ddi-l2.py
Library		Collections
Resource    resources/auth.robot

*** Variables ***
${FILE_NAME}	input.json

*** Test Cases ***
Get Token from Keycloak (TD_DDI_GEN_002)
    Get and validate token
