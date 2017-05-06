build:
	docker build -t elixir-inotify ./

dev:
	docker run -ti -v ${PWD}:/opt/ingestory elixir-inotify /bin/bash

nonet:
	docker run -ti --network=none -v ${PWD}:/opt/ingestory elixir-inotify /bin/bash
