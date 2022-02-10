*** Settings ***
Library    RequestsLibrary
Library    Collections
Library     ../lib/ddi-l1.py
Library     ../lib/ddi-meta1.py
Library     ../lib/ddi-meta1.py

*** Keywords ***

IRODS API test
        [Arguments]     ${TOKEN}
        ${HEADERS}=    Create dictionary         Content-Type=application/json      Authorization=Bearer ${TOKEN}     charset=utf-8
        ${IRODS_body}=     Set Variable 	${IRODSAPI.meta_search}    
        log   ${HEADERS}
        log   ${IRODS_body}
        Create Session    session    ${API_hosts.irods_api}

#get list of datasets and verify ours is there
        ${response}=    POST On Session  session    /dataset/search/metadata     json=${IRODS_body}     headers=${HEADERS}
        log   ${response}
        Should be equal as strings    ${response.status_code}    200

        ${loc}= 	Create Dictionary 	access=${IRODSAPI.access} 	internalID=${IRODSAPI.internalID} 	project=${IRODSAPI.project}
        log 	${loc}
        ${res}= 	find by internalid 	${response.json()}	 ${IRODSAPI.internalID}
        log 	${res}
        ${l}=		Get Length	${res}
        Should be True		${l}==1
	Should be equal as strings		${res[0]['metadata']['title']}			${IRODSAPI.title} 
	Should be equal as strings		${res[0]['metadata']['creator'][0]}		${IRODSAPI.creator}

#insert new dataset
	${new}=	POST On Session  session    /dataset	json=${IRODSAPI.new}		headers=${HEADERS}
	log 	${new}
        Should be equal as strings    	${response.status_code}    200
	${id}=	Set Variable		${new.json()["internalID"]}
	log	${id}
#delete it
	${delbody}=	Create Dictionary	internalID=${id}	access=${IRODSAPI.new.access}	project=${IRODSAPI.new.project}
	${del}=	DELETE On Session  session    /dataset    json=${delbody}		headers=${HEADERS}
	log 	${del}
	Should be equal as strings      ${del.status_code}	201
	sleep 	5
#verify deletion
	Create Session    session2    ${API_hosts.staging_api}
	${req_id}=	Set Variable	${del.json()["request_id"]}
	${final}=	Wait Until Keyword Succeeds	10 min		10 sec		VERIFY DELETION		${req_id}	${HEADERS}
	log 		${final}

VERIFY DELETION
	[Arguments]     ${req_id}	${HEADERS}
	${queue}=	GET On Session  session2    /delete/${req_id}    headers=${HEADERS}
	log		${queue}
	${deletion_status} =  Get From Dictionary   ${queue.json()}     status
        ${del_status}=   Should be equal as strings       ${deletion_status}       Data deleted
