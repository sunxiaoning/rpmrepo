# rpmrepo
private rpm repo

## quick install

1. install all repo

```bash
make install-repoall

```
2. (option) install,config and op reposerver
    ```bash
    # install reposerver
    make install-reposerver

    # config reposerver
    make install-repoconf

    # start reposerver
    make start-reposerver

    # reload reposerver
    make reload-reposerver

    # stop reposerver
    make stop repo-server
    ```
3. install app
   ```bash
   yum install <app_name>
   ```

## install app

1. install repo
    ```bash
    APP_NAME=<app_name> APP_VERSION=<app_version> make install-repo
    ```
2. (option) install,config and op reposerver,see quick install...

3. install app
   ```bash
   yum install <app_name>
   ```
