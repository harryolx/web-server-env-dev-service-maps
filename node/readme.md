# How to create docker image
```
docker build -t my-node .
```

# How to create container
```
docker run --name this-node \
-e "MESSAGE=First instance" \
-p 8081:8080 \
-v /var/www/html/node:/usr/src/app \
-d my-node
```