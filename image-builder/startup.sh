#!/bin/bash
service php7.0-fpm start
service cron start
service memcached start
nginx -g "daemon off;"
