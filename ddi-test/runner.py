#!/bin/python
import requests
import robot
import sys
import datetime
import shutil
import os
import yaml
import argparse

def send_msg(hook, msg):
	payload = {'text': msg}
	requests.post(hook, json=payload)

if __name__ == '__main__':
	parser = argparse.ArgumentParser('Robot runner')
	parser.add_argument('--config', help='Path to YAML config file')
	parser.add_argument('--notify', help='If present, notification are sent')
	args = parser.parse_args()

	with open(args.config) as f:
		config = yaml.load(f, Loader=yaml.SafeLoader)

	hook = config['robot']['mattermost_hook']
	current_time = datetime.datetime.now()

	for suite in config['robot']['suites']:
		stamp = "{0}_{1}".format(suite.split('.')[0], datetime.datetime.strftime(current_time, "%Y%m%d%H%M%S"))
		outfile = "output_{0}.xml".format(stamp)
		logfile = "log_{0}.html".format(stamp)
		reportfile = "report_{0}.html".format(stamp)

		result = robot.run(suite, variablefile=args.config, metadata='Application:dditest', output=os.path.join(config['robot']['output_path'], outfile), log=os.path.join(config['robot']['output_path'], logfile), report=os.path.join(config['robot']['output_path'], reportfile))

		if result > 0 and args.notify:
			send_msg(hook, '#### Tests failed \n {0} Log: {1}/{2}'.format(suite,config['robot']['output_url'], logfile))

