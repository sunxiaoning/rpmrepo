# rpmrepo
private rpm repo

## quick install

1. install all repo
    
    ```bash
    # method1: when use local repo source
    make install-repoall

    # method2: when use server repo source
    USE_REPO_SERVER=1 SERVER_NAME=<repo_server> make install-repoall
    ```

2. (optional) install repo store && install all repo without reposerver
    
    ```bash
    make local-install
    ```

3. (optional) install repo store, install reposerver && install all repo with local reposerver

    ```bash
    make server-install
    ```

## install app repo

1. install galera4 cluster repo
    
    ```bash
    # method1: when use local repo source
    make install-repogalera4

    # method2: when use server repo source
    USE_REPO_SERVER=1 SERVER_NAME=<repo_server> make install-repogalera4
    ```

2. install nginx repo
     ```bash
    # method1: when use local repo source
    make install-reponginx

    # method2: when use server repo source
    USE_REPO_SERVER=1 SERVER_NAME=<repo_server> make install-reponginx
    ```


3.  install generic repo
    
    ```bash
    APP_NAME=<app_name> APP_VERSION=<app_version> make install-repo
    ```

