NAME = necbaas/ssepush-server

PORT_OPTS = -p 38080:8080

VOLUME_OPTS = -v $(PWD)/logs:/opt/tomcat/logs:rw

PROXY = --build-arg http_proxy=$(http_proxy) --build-arg https_proxy=$(http_proxy)

all: ssepush-server

#download:
#	@./download.sh

ssepush-server: Dockerfile
	docker image build $(PROXY) -t $(NAME) .

rmi:
	docker image rmi $(NAME)

bash:
	docker container run -it --rm $(NAME) /bin/bash

start:
	docker container run -d $(PORT_OPTS) $(VOLUME_OPTS) $(NAME)

push:
	docker image push $(NAME)

