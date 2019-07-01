#!/usr/bin/env python3
# Simple script to send random alerts to Alerta for load testing.

import random
import subprocess
import time

alerta_env = ['Production', 'Development', 'Storage', 'Network']
alerta_res = ['web', 'app', 'db']
alerta_svc = ['nginx', 'crond', 'userapp1', 'eth0-in']
alerta_sev = ['major', 'minor', 'critical', 'ok']
alerta_event = 'just dummy stuff'

def create_alert():

    alert_env = random.choice(alerta_env)
    alert_res = random.choice(alerta_res)
    alert_res = '{}{:02d}'.format(alert_res, random.randint(1,20))
    alert_svc = random.choice(alerta_svc)
    alert_sev = random.choice(alerta_sev)
    alert_event = alerta_event

    return 'alerta send --environment {} --resource {} --service {} --event "{}" --severity {}'.format(alert_env, alert_res, alert_svc, alert_event, alert_sev)


if __name__ == "__main__":


    while True:
        alert_cmd = create_alert()

        print(alert_cmd)

        subprocess.call(alert_cmd, shell=True)

        time.sleep(0.2)
