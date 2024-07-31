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

build-repoall:
	./hack/build.sh repoall

install-repo: build-repo
	./hack/install.sh repo

install-nginx: build-nginx
	./hack/install.sh nginx

install-galera4: build-galera4
	./hack/install.sh galera4

install-repoall: build-repoall
	./hack/install.sh repoall

install-repostore:
	./hack/install.sh repostore

install-reposerver:
	./hack/install.sh reposerver

install-repoconf:
	./hack/install.sh repoconf

start-reposerver:
	./hack/run.sh start

reload-reposerver:
	./hack/run.sh reload

stop-reposerver:
	./hack/run.sh stop