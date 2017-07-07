.PHONY: default build push

name_space = devopsfloripa
image_name = node-web-app:1

default: build

build:
	docker build -t $(name_space)/$(image_name) .

push:
	docker push $(name_space)/$(image_name)

