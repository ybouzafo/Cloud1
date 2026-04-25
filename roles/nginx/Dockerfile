FROM debian:oldstable

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install nginx openssl


COPY conf/default /etc/nginx/sites-available/default

COPY tools/script.sh .
RUN chmod +x ./script.sh

CMD  ["/bin/bash" , "script.sh"]