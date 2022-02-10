*** Settings ***
Library	    lib/ddi-l1.py
Library	    lib/ddi-l2.py
Library		Collections
Resource    resources/auth.robot
Resource    resources/irods.robot

*** Test Cases ***
Put file to federated LRZ iRODS zone
    ${session}=     Get iRODS session from token
    Log     ${federated_irods.destination_path}
    Put file and read it back       ${session}  ${federated_irods.destination_path}

*** Test Cases ***
Put file to federated IT4I iRODS zone
    ${session}=     Get iRODS session from token
    Log     ${federated_irods_2.destination_path}
    Put file and read it back       ${session}  ${federated_irods_2.destination_path}

