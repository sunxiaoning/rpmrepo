# rpmrepo
private rpm repo

## quick install

1. install all repo
    
    ```bash
    # method1: when use official repo source
    make install

    # method2: when use private repo source
    REPO_SOURCE=1 REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make install

    # method3: when use local repo source
    REPO_SOURCE=2 REPO_LOCAL_ROOT_PATH=<repo local root path> make install
    ```
2. (optional) install repo store, install reposerver && install all repo with local reposerver

    ```bash
    REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make server-install
    ```

3. (optional) install repo store && install all repo without reposerver
    
    ```bash
    REPO_LOCAL_ROOT_PATH=<repo local root path> make local-install
    ```

## install app repo

1. install galera4 cluster repo
    
    ```bash
    # method1: when use official repo source
    make install-repogalera4

    # method2: when use private repo source
    REPO_SOURCE=1 REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make install-repogalera4

    # method3: when use server repo source
    REPO_SOURCE=2 REPO_LOCAL_ROOT_PATH=<repo local root path> make install-repogalera4
    ```

2. install nginx repo
     ```bash
    # method1: when use official repo source
    make install-reponginx

    # method2: when use private repo source
    REPO_SOURCE=1 REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make install-reponginx

    # method3: when use server repo source
    REPO_SOURCE=2 REPO_LOCAL_ROOT_PATH=<repo local root path> make install-reponginx
    ```


3.  install generic repo
    
    ```bash
    # method1: when use official repo source
    APP_NAME=<app_name> APP_VERSION=<app_version> make install-repo

    # method2: when use private repo source
    APP_NAME=<app_name> APP_VERSION=<app_version> REPO_SOURCE=1 REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make install-repo

    # method3: when use server repo source
    APP_NAME=<app_name> APP_VERSION=<app_version> REPO_SOURCE=2 REPO_LOCAL_ROOT_PATH=<repo local root path> make install-repo
    ```

