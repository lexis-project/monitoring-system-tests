*** Settings ***
Library	    lib/ddi-l1.py
Library	    lib/ddi-l2.py
Library		Collections
Resource    resources/auth.robot
Resource    resources/irods.robot

*** Test Cases ***
Put file in iRODS and read it back with plain iRODS password (TD_DDI_GEN_003)
    ${session}=     Get iRODS session from password
    ${irods_home}=	get_irods_home  ${irods}
    Log     ${session}
    Put file and read it back       ${session}  ${irods_home}

Put file in iRODS and read it back with OpenID token (TD_DDI_GEN_004)
    ${session}=     Get iRODS session from token
    ${irods_home}=	get_irods_home  ${irods}
    Put file and read it back       ${session}  ${irods_home}
