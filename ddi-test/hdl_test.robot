*** Settings ***
Library	    lib/hdl_test.py
Library		Collections
Resource    resources/b2hdl_test.robot

*** Test Cases ***
Test HANDLE system availability (TD_B2_HDL_001)
     Create handle and delete it


