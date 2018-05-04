# coding: utf-8 
from __future__ import unicode_literals
import yaml
import datetime
import time
import logging
import os

import requests


morse_url = os.environ.get('MORSE_URL')
headers = {
    'Client-Id': os.environ.get('MORSE_CLIENT_ID'),
    'Content-Type': 'application/json',
}


logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s %(levelname)s %(filename)s:%(lineno)d %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)


def load_tasks(filename):
    logging.debug('loading tasks from %s', filename)
    with open(filename, 'r') as f:
        tasks = yaml.load(f)
    return tasks


def save_tasks(tasks, filename):
    logging.debug('saving tasks to %s', filename)
    with open(filename, 'w') as f:
        yaml.dump(tasks, f, allow_unicode=True)

def send_sms(task):
    need_send = False
    for trigger in task['triggers']:
        send_time = trigger['send_time']
        if not trigger.get('finished', False) and send_time <= datetime.datetime.now():
            need_send = True
            trigger['finished'] = True
    if not need_send:
        return

    phone_number_list = task['recipients']
    message = task['message']
    logging.info('send %d sms %s to %s', len(phone_number_list), message, phone_number_list)

    failed_count = 0
    for phone_number in phone_number_list:
        payload = {
            'uid': 0,
            'phone_number': str(phone_number),
            'message': message,
        }
        try:
            r = requests.post(morse_url, headers=headers, json=payload)
        except Exception as e:
            failed_count += 1
            logging.error('send to %s error, %s', phone_number, e)
            continue
        if r.status_code != requests.codes.ok:
            failed_count += 1
            logging.error('send to %s error, %s', phone_number, r.text)
            continue
    logging.info('send sms finished, total: %d, error: %d', len(phone_number_list), failed_count)

def run_forever(tasks):
    try:
        while True:
            for task in tasks:
                send_sms(task)
            time.sleep(5)
            save_tasks(tasks, 'sms-tasks-runtime.yml')
    except Exception as e:
        logging.fatal('%s', e)


def main():
    tasks = load_tasks('sms-tasks.yml')
    logging.debug(tasks)
    run_forever(tasks)


if __name__ == "__main__":
    main()

