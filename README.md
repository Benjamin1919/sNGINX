# sNGINX
  A smaller, safer and static compiled NGINX docker image.

## Feature
- Including almost all the official modules (except perl, otel, njs and experimental modules)
- With HTTP/3 support
- Built with the latest released source code of Nginx (mainline), OpenSSL and other dependencies
- OS/Arch: linux/amd64, linux/arm64
- Statically compiled on Debian and packaged with distroless
- The size of this image is less than 10MB (<20MB even after decompressing), much smaller than the official nginx image
- Safer than the official nginx image thanks to distroless (no shell inside the image)
- Daily check the latest version of nginx and build a new image if a new version comes out
- Add webp support for http_image_filter_module
- With GeoIP2 support (since 1.31.2)

## Usage
Before creating a docker container, you should do these things on your host:
* Put your own `nginx.conf` ([reference](https://raw.githubusercontent.com/Benjamin1919/sNGINX/refs/heads/main/conf/nginx.conf)) in `/usr/local/etc/nginx` and other conf files in `/usr/local/etc/nginx/conf.d`
* Install or copy your certificates to `/usr/local/etc/nginx/ssl`
* Copy the resource files of your website to `/usr/local/share/html`
* Create the directory `/var/log/nginx`

Then run the command:
```
docker volume create nginx_tmp && \
docker run -d --name sNGINX --network host --restart unless-stopped \
    --mount type=bind,src=/usr/local/etc/nginx/nginx.conf,dst=/etc/nginx/nginx.conf,ro \
    --mount type=bind,src=/usr/local/etc/nginx/conf.d,dst=/etc/nginx/conf.d,ro \
    --mount type=bind,src=/usr/local/etc/nginx/ssl,dst=/etc/nginx/ssl,ro \
    --mount type=bind,src=/usr/local/share/html,dst=/usr/local/share/html,ro \
    --mount type=bind,src=/var/log/nginx,dst=/var/log/nginx \
    --mount type=volume,src=nginx_tmp,dst=/var/tmp/nginx \
    benjamin1919/snginx
```
* Note: It's better not to mount the whole  `/etc/nginx` directory because other files in this directory (fastcgi_params, fastcgi.conf, koi-utf, koi-win, mime.types, scgi_params, uwsgi_params, win-utf) will disappear
* Mirror: ghcr.io/benjamin1919/snginx

## Default Behavior
If a container is simply created using the command:
```
docker run -d --name sNGINX --network host benjamin1919/snginx
```
- The container will listen on port 8080 (both IPv4 and IPv6) and a welcome page of nginx will appear if you visit `http://localhost:8080` with a browser on your host
- Two anonymous volumes will be created (`/var/log/nginx` and `/var/tmp/nginx`) to avoid the container getting larger unexpectedly
<br/>
Anonymous volumes remain after the container is deleted, so it's recommended to mount explicitly in production environment.

- `/var/log/nginx` stores access/error logs of nginx. Mount it on a certain directory (e.g. `/var/log/nginx`) of your host in order to inspect logs:
```
docker run ... \
    --mount type=bind,src=/var/log/nginx,dst=/var/log/nginx \
    benjamin1919/snginx
```
- `/var/tmp/nginx` stores temporary files of nginx. Mount it to a named volume because there's no need to inspect these files:
```
docker volume create nginx_tmp && \
docker run ... \
    --mount type=volume,src=nginx_tmp,dst=/var/tmp/nginx \
    benjamin1919/snginx
```

## GeoIP2
This image includes GeoIP2 module (ngx_http_geoip2_module and ngx_stream_geoip2_module) since version 1.31.2.
<br/>
See tutorial here: [Example Usage](https://github.com/leev/ngx_http_geoip2_module#example-usage)

## Reference
- [Building Nginx from Sources](https://nginx.org/en/docs/configure.html)
- [docker/github-builder](https://github.com/docker/github-builder)
- [leev/ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module)
