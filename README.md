# RPM Repo
Primarily provides installation functionality for application YUM repositories, and also offers installation functionality for private and local repositories related to YUM.

## Quick Install

1. Install all repo
    
    ```bash
    # Method1: When use official repo source
    make install

    # Method2: When use private repo source
    REPO_SOURCE=1 REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make install

    # Method3: When use local repo source
    REPO_SOURCE=2 REPO_LOCAL_ROOT_PATH=<repo local root path> make install
    ```
2. (Optional) Install reposerver && install all repo with local reposerver

    ```bash
    REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make server-install
    ```

3. (Optional) Install repo store && install all repo with local store
    
    ```bash
    REPO_LOCAL_ROOT_PATH=<repo local root path> make local-install
    ```

## Install app repo

1. Install galera4 cluster repo
    
    ```bash
    # Method1: When use official repo source
    make install-repogalera4

    # Method2: When use private repo source
    REPO_SOURCE=1 REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make install-repogalera4

    # Method3: When use server repo source
    REPO_SOURCE=2 REPO_LOCAL_ROOT_PATH=<repo local root path> make install-repogalera4
    ```

2. Install nginx repo
     ```bash
    # Method1: When use official repo source
    make install-reponginx

    # Method2: When use private repo source
    REPO_SOURCE=1 REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make install-reponginx

    # Method3: When use server repo source
    REPO_SOURCE=2 REPO_LOCAL_ROOT_PATH=<repo local root path> make install-reponginx
    ```


3.  Install generic repo
    
    ```bash
    # Method1: When use official repo source
    APP_NAME=<app_name> APP_VERSION=<app_version> make install-repo

    # Method2: When use private repo source
    APP_NAME=<app_name> APP_VERSION=<app_version> REPO_SOURCE=1 REPO_SERVER_PROTOCOL=<http/https> REPO_SERVER_NAME=<repo server name> make install-repo

    # Method3: When use server repo source
    APP_NAME=<app_name> APP_VERSION=<app_version> REPO_SOURCE=2 REPO_LOCAL_ROOT_PATH=<repo local root path> make install-repo
    ```

