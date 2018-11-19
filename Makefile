PORT_OPTS = -p 38080:8080

VOLUME_OPTS = -v $(PWD)/logs:/opt/tomcat/logs:rw

NAME = necbaas/ssepush-server

all: ssepush-server

#download:
#	@./download.sh

ssepush-server: Dockerfile
	docker image build -t $(NAME) .

rmi:
	docker image rmi $(NAME)

bash:
	docker container run -it --rm $(NAME) /bin/bash

start:
	docker container run -d $(PORT_OPTS) $(VOLUME_OPTS) $(NAME)

push:
	docker image push $(NAME)

