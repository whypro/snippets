FROM python:2-alpine3.6

WORKDIR /usr/src/sms-sender

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY sms-sender.py ./
COPY sms-tasks-prd.yml ./sms-tasks.yml

RUN apk add --no-cache tzdata
ENV TZ Asia/Shanghai

CMD [ "python", "./sms-sender.py" ]
