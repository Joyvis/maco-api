lsof -ti:3000 | xargs kill
if [ -f /tmp/pids/server.pid ]; then
  rm /tmp/pids/server.pid
fi

git pull
export RAILS_ENV=production
export DATABASE_HOST=maco-api-production.c8le0m846q8h.us-east-1.rds.amazonaws.com

bin/rails db:migrate
bin/rails s -b 0.0.0.0 -p 3000 > /dev/null 2>&1 &
