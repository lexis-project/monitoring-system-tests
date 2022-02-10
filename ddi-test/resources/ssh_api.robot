*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library     ../lib/ddi-l1.py
Library     ../lib/ddi-meta1.py

*** Keywords ***

SSH API test
        [Arguments]     ${TOKEN}
        ${HEADERS}=    Create dictionary         Content-Type=application/json      Authorization=Bearer ${TOKEN}     charset=utf-8
	${pubkey}=     Get File                  ${SSH.key}
        ${SSH_body}=    Create dictionary     host=${SSH.host}	pubkey=${pubkey}	path=${SSH.path}
        log   ${HEADERS}
        log   ${SSH_body}
        Create Session    session    ${API_hosts.ssh_api}
        ${response}=    POST On Session  session    /sshfsexport     json=${SSH_body}     headers=${HEADERS}
#        ${req_id} =  Get From Dictionary   ${response.json()}     request_id
# Get From List
        log   ${response}
        Should be equal as strings    ${response.status_code}    201
        ${user}= 	Get From Dictionary 	${response.json()} 	user

        ${delbody}= 	Create Dictionary 	user=${user}		path=${SSH.path}
	log		${delbody}
	${delresponse}=		DELETE On Session  session    /sshfsexport     json=${delbody} 	headers=${HEADERS} 
	log		${delresponse}
        Should be equal as strings	${delresponse.status_code}		204

        
        sleep   30 
