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

install-reponginx: 
	$(MAKE) build-nginx
	./hack/install.sh nginx

install-repogalera4: 
	$(MAKE) build-galera4
	./hack/install.sh galera4

install-repoall: install-reponginx install-repogalera4

install: install-repoall

install-repostore:
	./hack/install.sh repostore

install-reposerver:
	./hack/install.sh reposerver

server-install: install-reposerver
	REPO_SOURCE=1 $(MAKE) install-repoall

local-install: 
	REPO_SOURCE=2 $(MAKE) install-repostore install-repoall