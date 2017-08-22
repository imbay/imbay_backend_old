####**Linux Ubuntu 16.04 LTS**

---
```
sudo su root
rm -rf /var/lib/dpkg/lock
apt-get update
apt-get install -f
apt autoremove
```
##### Install Ruby
```
apt-add-repository ppa:brightbox/ruby-ng &&\
apt update &&\
apt install autoconf bison build-essential &&\
libxml2-dev libssl-dev libyaml-dev &&\
libreadline6-dev zlib1g-dev libncurses5-dev &&\
libffi-dev libgdbm3 libgdbm-dev &&\
sqlite3 libsqlite3-dev &&\
ruby2.4 ruby2.4-dev
```
##### Install Ruby on Rails
```
gem install bundler:1.15.3 rails:5.1.2 --no-ri --no-rdoc
```
##### Install NodeJS & NPM
```
apt install curl &&\
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - &&\
apt update &&\
apt install -y nodejs=6.11.*
```
##### Configuration GIT
```
git config --global user.name "Nurasyl Aldan" &&\
git config --global user.email "nurassyl.aldan@gmail.com" &&\
git config user.name &&\
git config user.email
```
##### Install PostgreSQL
```
touch /etc/apt/sources.list.d/pgdg.list && echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \ apt-key add - apt-get update && apt-get install postgresql-9.6 libpq-dev pgadmin3
```
##### Create database in PostgreSQL
```
sudo su postgres
psql
CREATE USER nurasyl WITH PASSWORD '12345';
ALTER ROLE nurasyl SET client_encoding TO 'utf8';
ALTER ROLE nurasyl SET default_transaction_isolation TO 'SERIALIZABLE';
ALTER ROLE nurasyl SET timezone TO 'UTC';
CREATE DATABASE imbay;
GRANT ALL PRIVILEGES ON DATABASE imbay TO nurasyl;
\du
\q
psql -d app1 -U nurasyl -h 127.0.0.1 -p 5432
\c
\q
exit
```
##### Create database in RoR
```
rake db:drop:all
rake db:create:all
```
##### Migrate
```
RAILS_ENV=production rake db:migrate
RAILS_ENV=test rake db:migrate
RAILS_ENV=development rake db:migrate
```
##### Install redis
```
wget http://download.redis.io/releases/redis-4.0.1.tar.gz
tar xzf redis-4.0.1.tar.gz
cd redis-4.0.1
make
sudo cp src/redis-server /usr/local/bin/
sudo cp src/redis-cli /usr/local/bin/
```
##### Run redis server
```
redis-server ./redis.conf
```
##### Run RoR server
```
rails s
```
##### Git commit
```
git rm -r --cached . && git reset && git add --all && git commit -m "dev" && git push origin master
```
##### Save in development
```
git checkout dev && sudo chmod 777 save.sh && ./save.sh
```

