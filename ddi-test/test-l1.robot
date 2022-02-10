*** Settings ***
Library		ddi-l1.py
Library		Collections

*** Variables ***
${FILE_NAME}	input.json
${USERNAME}	*

*** Test Cases ***
Test connection
	${Machines} =	load_machines	${FILE_NAME}
	${IPs} =	get_all_IPs	${Machines}
	FOR	${IP}	IN	@{IPs}
		Log	${IP}
		${IP_check}=	ping	${IP}
		Should Be True	"${IP_check}"	"True"
	END

Test ports
        ${Machines} =   load_machines   ${FILE_NAME}
        FOR    ${machine}   IN      @{Machines}
               Log     ${machine}
							 ${IP} =		Get From Dictionary	${machine}	ip
               ${ports} =	Get From Dictionary     ${machine}      ports
               ${check} =	check_ports	${IP}	${ports}
						   Run Keyword If		"${check}"=="False"	Run Keyword And Continue On Failure	Fail	"Port is closed"
				END
