VPK

[RUN AS ROOT]  
1. Setup Docker on Host OS (Ubuntu 16.04 LTS) 
https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository  
```bash
# 1.1 Install dependancies  
$ sudo apt-get install apt-transport-https ca-certificates curl software-properties-common 

# 1.2 Add key  
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  

# 1.3 Add repo  
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"  

# 1.4 Install docker (specific version)  
$ sudo apt install docker-ce=17.06.2~ce-0~ubuntu  

# 1.5 Install docker compose  
$ sudo apt install docker-compose  

# 1.6 Add user to docker group (so docker can be managed as non-root)
$ sudo usermod -aG docker $USER

#1.7 Create folder for user where application will be stored
# For example : /home/$USER
```

[RUN AS $USER FROM NOW ON]  
2. Build Docker image & composer file for running nginx+php+perconadb+memcached+composer+nodejs  
```bash
# [in folder image-builder]  
$ docker build -t vpk .  
```

3. Start Docker environment (in folder, where docker-compose.yml is located)  
```bash
# 3.1 Create webroot folder (otherwise docker will overwrite it with root owner)
$ mkdir webroot
FIXME: maybe include empty webroot in git repo?
$ docker-compose up -d  
# default database and user will be created on first run

# and enable it to run on startup:
# edit crontab: 
$ crontab -e
# and add following entry (double check paths): 
@reboot /usr/bin/docker-compose -f /[path to project]/docker-compose.yml -p vpk start
```

4. Pull project from WD Gitlab  
```bash
# 4.1 generate pub/priv keys  
$ ssh-keygen -t rsa -C "info@whitedigital.eu" -b 4096

# 4.2 Add ssh public key to gitlab
$ cat ~/.ssh/id_rsa.pub

# 4.3 Clone project in webroot folder  
$ git clone [..project SSH URL from gitlab..] .  
```

5. BUILD project  
```bash
# 5.1 Login to running docker container  
$ docker exec -it vpk_webserver_1 bash  

# 5.2 Yii framework install and config  
$ cd /var/www/html  
$composer install
FIXME: composer install default environment - PROD?

# edit: 
common/config/main-local.php - change db user/pwd/dbname  
common/config/params-local.php - add domain & back_end_domain
$ composer install #seems that this include php init  
$ php init  
$ php yii migrate  

# 5.3 Permissions to write folders 
$ chmod -R a+w runtime  
$ chmod -R a+w frontend/web/ ... 
FIXME: which folers?

# 5.4 JS/CSS build   
# (both frontend and backend folders)  
$ npm run build
```



TODO 
- SSL certs
- zabbix monitoring
- figure out exclude folders for rsync (assets, config, ... ?)
- image server - https://stumbles.id.au/nginx-dynamic-image-resizing-with-caching.html
- Percona server: how to create database and user creds?
- DNS name in nginx config files ?
- SQL dump backup scripts
