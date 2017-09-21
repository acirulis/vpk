FROM ubuntu:latest
LABEL maintainer "info@whitedigital.eu"

#some general stuff & nginx
RUN apt-get update \
&& apt-get -y upgrade \
&& apt-get install -y vim bzip2 curl nginx

#php & php modules
RUN apt-get install -y php-fpm \
    && apt-get install -y php-mysql php-mbstring php-gd php-bcmath php-zip php-xml php-curl php-intl php-memcached

# #Expose http, https
EXPOSE 80 443

# forward request and error logs to docker log collector
#RUN ln -sf /dev/stdout /var/log/nginx/access.log \
# 	&& ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /root
ADD startup.sh ./
RUN chmod a+x startup.sh


ADD php.ini /etc/php/7.0/fpm/php.ini

# Installing composer globally
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Installing nodejs and npm 
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -y install nodejs

CMD ["/bin/bash"]
