# monitoring-system-tests
This repository contains a list of LEXIS testcases (collected from the individual LEXIS modules), and scripts to execute the tests specified in the list of testcases. Testcases are documented in the directory `docs`. Some testcases are implemented in scripts using Robot framework in directory `ddi-test`.

## Acknowledgement
This code repository is a result / contains results of the LEXIS project. The project has received funding from the European Union’s Horizon 2020 Research and Innovation programme (2014-2020) under grant agreement No. 825532.

## Subdirectory ddi-test
The testsuite in this directory, based on the "robot" framework, provides a mechanism to test the Lexis DDI according to collected testcases.

### Configuration and development
The test cases are located in root directory. They should reuse keywords from the `resources` directory. Additional Python scripts are in `lib`.

#### Config file
Entire configuration is stored in the vars.yaml file. The sections are self explanatory.

The `robot` section contains list of root level test suites to run.

Notifications are sent by the runner.py script and are enabled by setting `notify` key to True in the robot section.

#### Requirements
Python 3, other requirements are in requirements.txt

`python3 -m venv venv`
`source venv/bin/activate`
`pip install -r requirements.txt`

### Running
Variables for the test cases are set in vars.yaml file passed by the `--config` argument.
Notifications are sent only if `--notify` flag is passed.

Example:

`python runner.py --config vars.yaml --notify`

## Maintainers
Mohamad Hayek <mohamad.hayek@lrz.de>
Martin Golasowski <martin.golasowski@vsb.cz>
