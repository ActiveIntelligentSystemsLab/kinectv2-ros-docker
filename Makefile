NAME=kinectv2-ros
VERSION=dev

build:
	docker build -t $(NAME):$(VERSION) .
