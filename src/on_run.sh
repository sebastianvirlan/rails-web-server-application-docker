redis-server /etc/redis.conf
sidekiq -e "$APP_ENV" -d -l tmp/sidekiq.log