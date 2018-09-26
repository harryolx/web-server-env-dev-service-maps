#apache

```
docker run --name this-apache \
-p 80:80 \
-v /var/www/html:/var/www/html \
-v /var/www/html/\.ssh:/root/\.ssh \
-v /var/www/html/auth.json:/root/\.composer/auth.json \
-d harryosmar/web-server-env-dev-service-maps
```