# sNGINX
  A smaller, safer and static compiled NGINX docker image.

## Feature
- Including almost all the official modules (except perl, otel, njs and experimental modules)
- With HTTP/3 support
- Built with latest release source code of nginx, openssl and other dependencies
- Statically compiled on Debian and packaged by distroless
- The size of this image is less than 20MB, much smaller than the official nginx image
- Safer than the official nginx image thanks to distroless (no shell inside the image)

## Usage
Before creating a docker container, you should do these things on your host:
* Put your own `nginx.conf` in `/usr/local/etc/nginx` and other conf files in `/usr/local/etc/nginx/conf.d`
* Install or copy your certificates to `/usr/local/etc/nginx/ssl`
* Copy the resource files of your website to `/usr/local/share/html`
* Create the directory `/var/log/nginx`

Then run the command:
```
docker run -d --name sNGINX --network host \
    --mount type=bind,src=/usr/local/etc/nginx/nginx.conf,dst=/etc/nginx/nginx.conf,ro \
    --mount type=bind,src=/usr/local/etc/nginx/conf.d,dst=/etc/nginx/conf.d,ro \
    --mount type=bind,src=/usr/local/etc/nginx/ssl,dst=/etc/nginx/ssl,ro \
    --mount type=bind,src=/usr/local/share/html,dst=/usr/local/share/html,ro \
    --mount type=bind,src=/var/log/nginx,dst=/var/log/nginx \
    ghcr.io/benjamin1919/snginx:latest
```
* Note: It's not recommended to mount the whole  `/etc/nginx` directory because other files in this directory (fastcgi_params, fastcgi.conf, koi-utf, koi-win, mime.types, scgi_params, uwsgi_params, win-utf) will disappear

## Default Behavior
If simply creat a container using the command:
```
docker run -d --name sNGINX --network host ghcr.io/benjamin1919/snginx:latest
```
- The container will listen on port 8080 (both IPv4 and IPv6) and a welcome page of nginx will appear if you visit `http://localhost:8080` with a browser on your host
- Two anonymous volumes will be created (`/var/log/nginx` and `/var/tmp/nginx`) to avoid the container getting larger unexpectedly

An anonymous volume won't be created if you mount the corresponding directory, for example:
```
--mount type=bind,src=/var/log/nginx,dst=/var/log/nginx
```
There's no need to mount `/var/tmp/nginx` because it stores temporary files of nginx. But if you insist, it's recommended to creat a named volume:
```
docker volume create nginx_tmp
```
then mount:
```
--mount type=volume,src=nginx_tmp,dst=/var/tmp/nginx
```

