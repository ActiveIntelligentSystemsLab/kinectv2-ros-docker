NAME=kinectv2-ros
VERSION=r35.1.0

build:
	docker build -t $(NAME):$(VERSION) .
