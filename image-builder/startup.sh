#!/bin/bash
service php7.0-fpm start
service cron start
nginx -g "daemon off;"
