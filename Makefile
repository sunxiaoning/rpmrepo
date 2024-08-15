init:
	@echo "Init env ..."

default: build-repo

# build the project

build-repo:
	./hack/build.sh repo

build-nginx:
	./hack/build.sh nginx

build-galera4:
	./hack/build.sh galera4

build: build-nginx build-galera4

install-repo: build-repo
	./hack/install.sh repo

install-nginx: build-nginx
	./hack/install.sh nginx

install-galera4: build-galera4
	./hack/install.sh galera4

install-repostore:
	./hack/install.sh repostore

install: install-nginx install-galera4

local-install: install-repostore install

install-reposerver:
	./hack/install.sh reposerver

uninstall-reposerver:
	./hack/uninstall.sh reposerver

install-repoconf:
	./hack/install.sh repoconf

start-reposerver:
	./hack/run.sh start

run-reposerver: install-reposerver install-repoconf start-reposerver

autorun-reposerver: install-repostore run-reposerver

reload-reposerver:
	./hack/run.sh reload

stop-reposerver:
	./hack/run.sh stop