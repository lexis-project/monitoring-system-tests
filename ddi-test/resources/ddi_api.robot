*** Settings ***
Library    RequestsLibrary
Library    Collections
Library     ../lib/ddi-l1.py
Library     ../lib/ddi-meta1.py

*** Keywords ***
STAGING API test
        [Arguments]     ${TOKEN}
        ${HEADERS}=    Create dictionary         Content-Type=application/json      Authorization=Bearer ${TOKEN}     charset=utf-8
        log   ${HEADERS}
        Create Session    session    ${API_hosts.staging_api}
        ${STAGING_body}=    Create dictionary     source_system=${STAGING_body.source_system}    source_path=${STAGING_body.source_path}    target_system=${STAGING_body.target_system}    target_path=${STAGING_body.target_path}       encryption=${STAGING_body.encryption}      compression=${STAGING_body.compression}
        ${response}=    POST On Session  session    /stage    json=${STAGING_body}     headers=${HEADERS}
        ${req_id} =  Get From Dictionary   ${response.json()}     request_id
        Should be equal as strings    ${response.status_code}    201
        sleep   90
        ${response2}=    GET On Session  session    /stage/${req_id}    headers=${HEADERS}
        ${staging_status} =  Get From Dictionary   ${response2.json()}     status
        Should be equal as strings       ${staging_status}       Transfer completed
        ${DLTE_STAGING_body}=    Create dictionary     target_system=${DLTE_STAGING_body.target_system}    target_path=${DLTE_STAGING_body.target_path}
        ${response3}=   DELETE On Session  session    /delete    json=${DLTE_STAGING_body}     headers=${HEADERS}
        ${req_id} =  Get From Dictionary   ${response3.json()}     request_id
        Should be equal as strings    ${response3.status_code}    201
        sleep   30
        ${response4}=    GET On Session  session    /delete/${req_id}    headers=${HEADERS}
        ${deletion_status} =  Get From Dictionary   ${response4.json()}     status
        ${del_status}=   Should be equal as strings       ${deletion_status}       Data deleted

