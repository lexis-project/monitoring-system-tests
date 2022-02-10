Library	    ../lib/hdl_test.py
Library		Collections
Library         BuiltIn

*** Keywords ***
Create handle and delete it
    ${handle}=	get_handle
    Should Not Be Equal As Strings   ${handle}    -1
    ${delete}=  delete_handle    ${handle}
    Should Not Be Equal As Strings   ${delete}    0
