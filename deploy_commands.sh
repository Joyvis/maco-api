if [ -f /tmp/pids/server.pid ]; then
  PID=$(cat /tmp/pids/server.pid)
  kill -9 $PID
  rm /tmp/pids/server.pid
fi

git pull
export RAILS_ENV=production
export DATABASE_HOST=maco-api-production.c8le0m846q8h.us-east-1.rds.amazonaws.com

bin/rails s -b 0.0.0.0 -p 3000 > /dev/null 2>&1 &
