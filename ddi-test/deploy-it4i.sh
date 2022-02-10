#!/bin/bash
echo "Backing up current versions"
tar zcf /opt/backup/ddi_test_backup_$(date +%Y%M%d_%H%m%S).tar.gz /opt/tests/ddi-test

echo "Deploying ddi-test"
rm -rf /opt/tests/ddi-test
mkdir /opt/tests/ddi-test
mkdir -p /opt/tests/ddi-test/logs
mkdir -p /opt/tests/ddi-test/logs_old
tar zvxf /tmp/ddi-test-it4i.tar.gz -C /opt/tests/ddi-test/

python3 -m venv /opt/tests/ddi-test/venv
source /opt/tests/ddi-test/venv/bin/activate
pip3 install --upgrade pip
pip3 install -r /opt/tests/ddi-test/requirements.txt
deactivate
rm /tmp/ddi-test-it4i.tar.gz

