.PHONY: default build push

name_space = lborguetti
image_name = haproxy

default: build

build:
	docker build -t $(name_space)/$(image_name) .

push:
	docker push $(name_space)/$(image_name)
