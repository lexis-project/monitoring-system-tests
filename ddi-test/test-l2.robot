*** Settings ***
Library   ddi-l1.py
Library		ddi-l2.py
Library   postgres.py
Library		Collections

*** Variables ***
${FILE_NAME}	input.json

*** Test Cases ***

Check ils
	${Machines}=	load_machines	${FILE_NAME}
  ${iRODS_dic}=  get_irods_dic   ${FILE_NAME}
	${token_dic}=	get_token
	${token}=	Get From Dictionary     ${token_dic}	access_token
	requestValidateToken	${token}	${iRODS_dic}
	${iRODS_lb}=	Get From Dictionary	${iRODS_dic}	lb_host
  ${iRODS_icats}=  Get From Dictionary     ${iRODS_dic}    hosts
	Log	"Checking ils on icat machines
  FOR     ${icat}   IN      @{iRODS_icats}
		${HOST}=	resolve_hostname	${Machines}	${icat}
		Log	Checking ${HOST}
		${session}=	get_session     ${token}        ${iRODS_dic}	${icat}		${Machines}
		Log	session is ${session}
		${path}=		Get From Dictionary	${iRODS_dic}	destination_path2
		${irods_list}=		test_ils	${session}	${path}
		Log	${irods_list}
	END

	Log	"Checking ils on the load balancer"
	${HOST}=        resolve_hostname        ${Machines}	${iRODS_lb}
        Log     Checking ${HOST}
        ${session}=	get_session     ${token}        ${iRODS_dic}    ${iRODS_lb}	${Machines}
        Log     session is ${session}
        ${path}=	Get From Dictionary     ${iRODS_dic}	destination_path2
        ${irods_list}=		test_ils        ${session}      ${path}
	Log	${irods_list}

Check iget
        ${Machines} =   load_machines   ${FILE_NAME}
        ${iRODS_dic}=  get_irods_dic   ${FILE_NAME}
        ${iRODS_lb}=  Get From Dictionary     ${iRODS_dic}    lb_host
        ${iRODS_icats}=  Get From Dictionary     ${iRODS_dic}    hosts
        Log     "Checking iget on icat machines
       	FOR     ${icat}   IN      @{iRODS_icats}
               ${HOST}=        resolve_hostname        ${Machines}	${icat}
               Log     Checking ${HOST}
               ${session}=	get_session     ${token}        ${iRODS_dic}    ${icat}		${Machines}
               Log     session is ${session}
               ${source_path}=                 Get From Dictionary	${iRODS_dic}	source_path1
               ${destination_path}=		Get From Dictionary	${iRODS_dic}	destination_path1
               test_iget        ${session}      ${source_path}		${destination_path}
							 Log	"cleaning dataset"
							 ${cleaned_path}=		clean_machine		${destination_path}	${iRODS_dic}
				END

		    Log     "Checking iget on the load balancer"
        ${HOST}=        resolve_hostname        ${Machines}	${iRODS_lb}
        Log     Checking ${HOST}
        ${session}=	get_session     ${token}        ${iRODS_dic}    ${iRODS_lb}	${Machines}
        Log     session is ${session}
        ${source_path}=                 Get From Dictionary     ${iRODS_dic}	source_path1
	${destination_path}=            Get From Dictionary     ${iRODS_dic}	destination_path1
	test_iget        ${session}      ${source_path}         ${destination_path}
	Log     "cleaning dataset"
	clean_machine           ${destination_path}     ${iRODS_dic}

Check iput
        ${Machines} =   load_machines   ${FILE_NAME}
        ${iRODS_dic}=  get_irods_dic   ${FILE_NAME}
        ${iRODS_lb}=  Get From Dictionary     ${iRODS_dic}    lb_host
        ${iRODS_icats}=  Get From Dictionary     ${iRODS_dic}    hosts
        Log     "Checking iget on icat machines
       	FOR     ${icat}   IN      @{iRODS_icats}
               ${HOST}=        resolve_hostname        ${Machines}	${icat}
               Log     Checking ${HOST}
               ${session}=  get_session     ${token}        ${iRODS_dic}    ${icat}	${Machines}
               Log     session is ${session}
               ${source_path}=                 Get From Dictionary     ${iRODS_dic}	source_path2
               ${destination_path}=            Get From Dictionary     ${iRODS_dic}	destination_path2
               test_iput        ${session}      ${source_path}         ${destination_path}
             		Log     "cleaning dataset"
             		clean_irods           ${session}	${destination_path}     ${iRODS_dic}
				END
				Log     "Checking iget on the load balancer"
        ${HOST}=        resolve_hostname        ${Machines}	${iRODS_lb}
        Log     Checking ${HOST}
        ${session}=	get_session     ${token}        ${iRODS_dic}    ${iRODS_lb}	${Machines}
        Log     session is ${session}
        ${source_path}=                 Get From Dictionary     ${iRODS_dic}	source_path2
        ${destination_path}=            Get From Dictionary     ${iRODS_dic}	destination_path2
        test_iput        ${session}      ${source_path}         ${destination_path}
	Log     "cleaning dataset"
        clean_irods           ${session}	${destination_path}     ${iRODS_dic}
