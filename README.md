VPK

1. Setup Docker on Host OS (Ubuntu 16.04 LTS)  
1.0 - https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
1.1  
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common  
1.2  
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  
1.3  
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"  
1.4  
sudo apt install docker-ce=17.06.2~ce-0~ubuntu  
1.5  
sudo apt install docker-compose  
  

2. Build Docker image & composer file for running nginx+php+perconadb+memcached+composer+nodejs  
[in folder image-builder]  
2.1 docker build -t vpm .  


3. Start Docker environment (in folder, where docker-compose.yml is located)  
3.1 docker-compose up -d  


4. Pull project from WD Gitlab  
4.1 generate pub/priv keys  
ssh-keygen -t rsa -C "info@whitedigital.eu" -b 4096  
4.2 add ssh public key to gitlab  
4.3 in webroot folder: git clone [..project SSH URL from gitlab..] .  


5. BUILD project  
5.1 log into running docker container  
docker exec -it vpk_webserver_1 bash  
5.2  
cd /var/www/html  
php init  
common/config/main-local.php - change db user/pwd/dbname  
composer install #seems that this include php init  
php yii migrate  
5.3 permissions  
chmod -R a+w runtime  
5.4 NPM ...  
