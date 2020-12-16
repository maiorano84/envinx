# About this Repo

This is a simple Docker image intended to expedite common NGINX setups
using Environment variables and string substitution.

This is NOT intended for use in Production, so deploy at your own risk.

# Usage

NGINX .conf files can be copied or mounted into `/docker-entrypoint.d/`. When run,
the entrypoint script will loop through all *.conf files located in this folder, and replace
any instances of `{{ENV_VARIABLE_NAME}}` with its corresponding value.

All resulting files from this folder will be copied into `/etc/nginx/conf.d` at runtime.

A simple example server block would look like the following:

*servers/default.conf*
```
server {
    listen       80;
    listen  [::]:80;
    server_name  {{NGINX_SERVER_NAME}};

    location / {
        root   {{NGINX_ROOT}};
        index  index.html index.htm;
    }
}
```

You can replace these variables by running the following command:

```
docker run -itd \
    -p 80:80
    -v $PWD/servers:/docker-entrypoint.d \
    -e NGINX_SERVER_NAME=localhost \
    -e NGINX_ROOT=/usr/share/nginx/html
    maiorano84/envinx
```

You will be greeted with the standard NGINX splash page when visiting http://localhost,
and the resulting file inside the container will look like so:

*/etc/nginx/conf.d/default.conf*
```
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
}
```
