# sNGINX
  A static compiled NGINX docker image with almost all the official modules (except perl, otel & njs). The size of the image is less than 20MB.

## Example
```
docker run -d --name sNGINX --network host \
    -v /usr/local/etc/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v /usr/local/etc/nginx/conf.d:/etc/nginx/conf.d \
    -v /usr/local/etc/nginx/ssl:/etc/nginx/ssl \
    -v /usr/local/share/html:/usr/local/share/html \
    ghcr.io/benjamin1919/snginx:latest
```
