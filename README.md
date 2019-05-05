# Alerta-Docker
Alerta-Docker is a implementation of Nick Satterly's [Alerta] project runing on Alpine Linux.

The Alerta-Docker container is not truly a microservice.  We've placed the following apps in the container for ease of deployment.
  - MongoDB
  - Nginx
  - UWSGI
 
Supervisor controls all of these apps and acts as our "init".

```
bash-4.4# supervisorctl status
mongod                           RUNNING   pid 8, uptime 2:33:55
nginx                            RUNNING   pid 7, uptime 2:33:55
uwsgi                            RUNNING   pid 9, uptime 2:33:55
```

### Build your image

```sh
$ docker build -t alerta .
```

### Run your container
Starting Alerta is a simple one-liner.

```sh
$ docker run -p 80:80 alerta "/usr/bin/supervisord -c /etc/supervisord.conf
```

### Use docker compose
Create a docker volume to store the mogodb data.

```sh
$ docker volume create alerta-db
$ docker-compose up -d
```

[Alerta]: <https://alerta.io>
