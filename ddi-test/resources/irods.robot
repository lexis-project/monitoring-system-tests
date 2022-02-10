*** Settings ***
Library	    ../lib/ddi-l1.py
Library	    ../lib/ddi-l2.py
Library		Collections

*** Keywords ***
Put file and read it back
    [Arguments]     ${session}  ${destination}
    # Put temporary file in destination folder
    irods_put_object   ${session}  test_data/test.txt   ${destination}/test.txt
    # List it
    ${result}=  irods_ls    ${session}  ${destination}
    Should contain match    ${result}   regexp=.*test\.txt.*
    # Read it
    ${result}=  irods_read_object  ${session}  ${destination}/test.txt
    Should contain match    ${result}   test
    # Delete it
    ${result}=  irods_delete_object  ${session}  ${destination}/test.txt
    # List it (and try to find it)
    ${result}=  irods_ls    ${session}  ${destination}
    Should not contain match    ${result}   test