# Alerta-Docker
Alerta-Docker is a implementation of Nick Satterly's [Alerta] project runing on Alpine Linux.

This deployment creates four containers:
  - nginx proxy
  - alerta-ui
  - alerta
  - mongodb

All incoming connections go to the proxy server and it distributes requests to the alerta server and alerta-ui based up on the URI.

 
Supervisor controls all the apps and acts as our "init".

```sh
bash-4.4# supervisorctl status
nginx                            RUNNING   pid 7, uptime 2:33:55
```

### Build your images

```sh
$ docker build -t proxy -f Dockerfile.proxy
$ docker build -t alerta -f Dockerfile.alerta
$ docker build -t alerta-db -f Dockerfile.alerta-db
$ docker build -t alerta-ui -f Dockerfile.alerta-ui
```

### Run your containers
Use docker-compose to bring up the four containers

```sh
$ docker-compose up -d
```

Its a good idea to keep the mongodb outside of the container.  Create a volume named "alerta-db" and mount thatto your alerta-db instance.

```sh
$ docker volume create alerta-db
```

Its also nice to have a pre-defined network for your containers.  We've created a dockern network named "monitor-net".  You can do the same or just remove that from the docker-compose.yml file.


[Alerta]: <https://alerta.io>
