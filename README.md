# Rails WEB Application running in a Docker Container

Steps to get Rails Server running:

```
docker build -t rails-server-build .
docker run --name rails-server -p 3000:3000 -ti rails-server-build
```

# ADVANCED OPTIONS

##### 1. Build the image

- with last ruby and rails version:

```
docker build --build-arg -t rails-server-build .
```

- with specified ruby or rails versions:

```
docker build --build-arg RUBY_V=<ruby-version> --build-arg RAILS_V=<rails-version> -t rails-server-build .
```

- with additional custom gems on the build just populate `src/gems` file with the desired gems e.g.

```
gem 'sidekiq', '~> 4.0.0'
```

- if you want to execute additional commands before the build, populate `src/on_build.sh` with commands e.g.:

```
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
```

##### 2. Run the image

- run image in development environment:

```
docker run --name rails-server -p 3000:3000 -ti rails-server-build
```

- run the image in other environment than development:

```
docker run --name rails-server -e APP_ENV=<environment> -p 3000:3000 -ti rails-server-build
```

- if you want to execute additional commands on image run, populate `src/on_run/sh` with commands e.g.:

```
redis-server /etc/redis.conf
sidekiq -e "$APP_ENV" -d -l tmp/sidekiq.log
```
