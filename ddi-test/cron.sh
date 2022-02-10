venv/bin/python runner.py --config vars.yaml --notify 1
venv/bin/testarchiver --repository dditests --series "run#$(date +'%Y%m%d_%H%M%S')" --config config_testarchiver.json --dont-require-ssl logs/output*
mkdir logs_old
mv logs/* logs_old/
