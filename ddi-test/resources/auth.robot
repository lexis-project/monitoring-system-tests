*** Settings ***
Library	    ../lib/ddi-l1.py
Library	    ../lib/ddi-l2.py
Library		Collections

*** Keywords ***
Get and validate token
    ${token}=   get_token_keycloak      ${keycloak}
    ${parsed_token}=    parse_token     ${token}
    Should contain  ${token}     access_token
    ${result_keycloak}=  validate_token_keycloak     ${keycloak}     ${token}
    Dictionary should contain item  ${result_keycloak}   active  True
    ${result_broker}=  validate_token_broker   ${irods}    ${token}
    Dictionary should contain item  ${result_broker}   active  True
    ${access_token}=    Get from dictionary     ${token}    access_token
    [Return]    ${access_token}

Get iRODS session from password
    Log list    ${machines}
    ${icat}=	Get From List	    ${machines}     ${irods.lb_host}
    Log     ${icat}
    ${session}=	    get_irods_session    ${irods}    ${icat['name']}
    Log     ${session}
    [Return]    ${session}

Get iRODS session from token
    # Get iRODS host and resolve home path
	${token}=   Get and validate token
    ${icat}=	Get From List	    ${machines}     ${irods.lb_host}
    ${session}=	get_irods_session     ${irods}    ${icat['name']}   ${token}
    [Return]    ${session}

