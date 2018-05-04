
VERSION = $(shell date +%Y%m%d%H%M)
build:
	docker build -t sms-sender .
.PHONY: build

push:
	docker tag sms-sender index-dev.qiniu.io/kelibrary/sms-sender
	docker push index-dev.qiniu.io/kelibrary/sms-sender
.PHONY: push

release:
	docker build -t sms-sender:${VERSION} .
	docker tag sms-sender:${VERSION} index-dev.qiniu.io/kelibrary/sms-sender:${VERSION}
	docker push index-dev.qiniu.io/kelibrary/sms-sender:${VERSION}
.PHONY: release

