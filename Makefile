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

install-reponginx: build-nginx
	./hack/install.sh nginx

install-repogalera4: build-galera4
	./hack/install.sh galera4

install-repoall: install-reponginx install-repogalera4

install-repostore:
	./hack/install.sh repostore

local-install: install-repostore install-repoall

install-reposerver:
	./hack/install.sh reposerver

server-install: install-reposerver
	USE_REPO_SERVER=1  $(MAKE) install-repoall