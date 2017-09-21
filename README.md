VPK

1. Setup Docker on Host OS (Ubuntu 16.04 LTS)  
https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository  
```bash
# 1.1 Install dependancies  
$ sudo apt-get install \  
    apt-transport-https \  
    ca-certificates \  
    curl \  
    software-properties-common 

# 1.2 Add key  
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  

# 1.3 Add repo  
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"  

# 1.4 Install docker (specific version)  
$ sudo apt install docker-ce=17.06.2~ce-0~ubuntu  

# 1.5 Install docker compose  
$ sudo apt install docker-compose  

# 1.6 Add user to docker group (so docker can be managed as non-root)
$ sudo usermod -aG docker $USER
```

2. Build Docker image & composer file for running nginx+php+perconadb+memcached+composer+nodejs  
```bash
# [in folder image-builder]  
$ docker build -t vpk .  
```

3. Start Docker environment (in folder, where docker-compose.yml is located)  
```bash
$ docker-compose up -d  

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

# 4.2 Add ssh public key (~/.ssh/id_rsa.pub) to gitlab

# 4.3 Clone project in webroot folder  
$ git clone [..project SSH URL from gitlab..] .  
```

5. BUILD project  
```bash
# 5.1 Login to running docker container  
$ docker exec -it vpk_webserver_1 bash  

# 5.2 Yii framework install and config  
$ cd /var/www/html  
# edit: 
common/config/main-local.php - change db user/pwd/dbname  
common/config/params-local.php - add domain & back_end_domain
$ composer install #seems that this include php init  
$ php init  
$ php yii migrate  

# 5.3 Permissions  
$ chmod -R a+w runtime  

# 5.4 JS/CSS build   
# (both frontend and backend folders)  
$ npm run build
```



TODO 
- SSL certs
- zabbix monitoring
- figure out exclude folders for rsync (assets, config, ... ?)
- image server
