# sNGINX
  A static compiled NGINX docker image with almost all the official modules (except perl, otel & njs). The size of the image is less than 20MB.

## Example
```
sudo docker run -d --name sNGINX --network host \
      -v /usr/local/etc/nginx/nginx.conf /etc/nginx/nginx.conf \
      -v /usr/local/etc/nginx/conf.d /etc/nginx/conf.d \
      ghcr.io/benjamin1919/snginx
```
