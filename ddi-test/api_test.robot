*** Settings ***
Library		Collections

Resource    resources/ddi_api.robot
Resource    resources/irods_api.robot
Resource    resources/ssh_api.robot
Resource    resources/gridmap_api.robot
Resource    resources/auth.robot
Variables   vars_lrz.yaml

*** Test Cases ***
Test STAGING API status (TD_DDI_API_STG_001)
     ${TOKEN}=    Get and validate token
     log    ${TOKEN}
     STAGING API test    ${TOKEN}

Test IRODS API status (TD_DDI_API_IRD_001)
     ${TOKEN}=    Get and validate token
     log    ${TOKEN}
     IRODS API test    ${TOKEN}

Test SSH API status (TD_DDI_API_SSH_001)
     ${TOKEN}=    Get and validate token
     log    ${TOKEN}
     SSH API test    ${TOKEN}

Test GRIDMAP API status (TD_DDI_API_GRM_001)
     ${TOKEN}=    Get and validate token
     log    ${TOKEN}
     GRIDMAP API test    ${TOKEN}
