# Dockerfile for Alerta on Alpine Linux container

FROM alpine:latest

RUN apk add bash supervisor nginx git gcc python3 mongodb 
RUN apk add python3-dev linux-headers postgresql-dev musl-dev libffi-dev

# Install Alerta
RUN pip3 install alerta-server alerta uwsgi

# Install and configure MongoDB
COPY config/mongod.conf /etc/mongod.conf
RUN mkdir -p /data/db; chown mongodb:mongodb /data/db

# Configure NGINX
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx-alerta.conf /etc/nginx/conf.d/alerta.conf
RUN chown nginx:nginx /etc/nginx/nginx.conf; chmod 644 /etc/nginx/nginx.conf
RUN chown nginx:nginx /etc/nginx/conf.d/alerta.conf; chmod 644 /etc/nginx/conf.d/alerta.conf

RUN mkdir -p /var/www/html; chown nginx:nginx /var/www/html
RUN mkdir -p /var/run/alerta; chown nginx:nginx /var/run/alerta
RUN mkdir -p /var/log/alerta; chown nginx:nginx /var/log/alerta

# Install proper version of Alerta front end
RUN wget -O alerta-web.tgz https://github.com/alerta/angular-alerta-webui/tarball/master
RUN tar zxvf alerta-web.tgz; cp -r alerta-angular-alerta-webui-*/app/* /var/www/html/
COPY config/config.json /var/www/html/config.json

# Configure UWSGI
COPY config/wsgi.py /var/www/wsgi.py
RUN chmod 755 /var/www/wsgi.py && chown nginx:nginx /var/www/wsgi.py
COPY config/uwsgi.ini /etc/uwsgi.ini

# Alerta configuration files
COPY config/alertad.conf /etc/alertad.conf
COPY config/alerta.conf /root/.alerta.conf

# Supervisord
RUN mkdir /etc/supervisord.d 
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/supervisord.d/mongod.ini /etc/supervisord.d/mongod.ini
COPY config/supervisord.d/nginx.ini /etc/supervisord.d/nginx.ini
COPY config/supervisord.d/uwsgi.ini /etc/supervisord.d/uwsgi.ini
