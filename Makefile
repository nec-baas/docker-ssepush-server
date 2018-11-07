PORT_OPTS = -p 38080:8080

VOLUME_OPTS = -v $(PWD)/logs:/opt/tomcat/logs:rw

NAME = necbaas/ssepush-server

all: download ssepush-server

download:
	@./download.sh

ssepush-server: Dockerfile
	docker build -t $(NAME) .

clean:

rmi:
	docker rmi $(NAME)

bash:
	docker run -it --rm $(NAME) /bin/bash

start:
	docker run -d $(PORT_OPTS) $(VOLUME_OPTS) $(NAME)

push:
	docker push $(NAME)

