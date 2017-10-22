#!/bin/sh

WORKDIR=/usr/src/app

cd /home/ && wget http://download.redis.io/redis-stable.tar.gz && tar xvzf /home/redis-stable.tar.gz && cd redis-stable && make

cp /home/redis-stable/src/redis-server /usr/local/bin/
cp /home/redis-stable/src/redis-cli /usr/local/bin/
cp /home/redis-stable/redis.conf /etc/redis.conf
sed -i '/daemonize/s/ .*/ yes/' /etc/redis.conf

sed -i "/end/i require 'sidekiq/web'" $WORKDIR/config/routes.rb
sed -i "/end/i mount Sidekiq::Web => '/sidekiq'" $WORKDIR/config/routes.rb
touch $WORKDIR/config/sidekiq.yml
echo ':queues:' >> $WORKDIR/config/sidekiq.yml
echo '  - [foo, bar]' >> $WORKDIR/config/sidekiq.yml