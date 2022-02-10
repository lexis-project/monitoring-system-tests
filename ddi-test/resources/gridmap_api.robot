*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library     ../lib/ddi-l1.py
Library     ../lib/ddi-meta1.py

*** Keywords ***

GRIDMAP API test
        [Arguments]     ${TOKEN}
        ${HEADERS}=    Create dictionary         Content-Type=application/json      Authorization=Bearer ${TOKEN}     charset=utf-8
        ${GRIDMAP_body}=    Create dictionary     dn=${GRIDMAP.dn}
        log   ${HEADERS}
        log   ${GRIDMAP_body}
        Create Session    session    ${API_hosts.gridmap_api}
        ${response}=    POST On Session  session    /gridmap     json=${GRIDMAP_body}     headers=${HEADERS}
#        ${req_id} =  Get From Dictionary   ${response.json()}     request_id
# Get From List
        log   ${response}
        Should be equal as strings    ${response.status_code}    201

        ${delbody}= 	Create Dictionary 	
	log		${delbody}
	${delresponse}=		DELETE On Session  session    /gridmap     json=${delbody} 	headers=${HEADERS} 
	log		${delresponse}
        Should be equal as strings	${delresponse.status_code}		204

        
        sleep   30 
