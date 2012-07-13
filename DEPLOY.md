
Run from host machine, while still connected to internet-enabled wireless network:

```
COUCHDB_PASSWORD="INSERT PASSWORD HERE"
MYSQL_PASSWORD="INSERT PASSWORD HERE" # User password.

# Get our list of hosts to connect to. CUSTOMIZE THIS.
HOSTS=
HOST_PREFIX=172.0.0.10
for ip in `seq 0 4`; do
  HOSTS="$HOSTS $HOST_PREFIX$ip"
done

# Put your SSH key in the authorized list so you can easily run rafts of commands.
SSH_PUB="`cat ~/.ssh/id_rsa.pub`"
for REMOTE in $HOSTS; do
  SSH_COMMAND='mkdir -p ~smashcon/.ssh && echo "'$SSH_PUB'" >> ~smashcon/.ssh/authorized_keys && chmod 0600 ~/.ssh/*'
  ssh smashcon@$REMOTE "$SSH_COMMAND"
done

for REMOTE IN $HOSTS; do
  ssh -tt smashcon@$REMOTE <<EOF
    echo 'export PADINRO_ENV=production' >> ~/.bashrc

    sudo -s <<EOS
      # CouchDB PPA
      apt-add-repository ppa:longsleep/couchdb

      # Pre-requisite libraries, tools and servers
      apt-get update
      apt-get install -y libyaml-dev libssl-dev build-essential git-core curl libcurl4-openssl-dev vim mysql-server mysql-client libmysqlclient-dev couchdb

      # CouchDB Setup
      sed -i"" -e 's/^;bind_address.*/bind_address = 0.0.0.0/' /etc/couchdb/local.ini
      service couchdb stop
      killall couchdb beam.smp
      service couchdb start
      
      # Ruby Base
      apt-get install -y ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 libopenssl-ruby1.9.1 libssl-dev zlib1g-dev
      update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 \
                               --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz \
                                         /usr/share/man/man1/ruby1.9.1.1.gz \
                               --slave   /usr/bin/ri ri /usr/bin/ri1.9.1 \
                               --slave   /usr/bin/irb irb /usr/bin/irb1.9.1 \
                               --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1

      # Symlinks for /usr/bin/ruby and gem; follow prompts:
      update-alternatives --config ruby # Prompt: 2, or may not be required at all.
      update-alternatives --config gem  # Prompt: 2, ... ditto.

      # Ruby Libraries
      gem install bundler

      # Passenger
      gem install passenger

      # Nginx; follow prompts:
      # 1
      # <enter>
      # <enter>
      passenger-install-nginx-module

      echo -e "\n127.0.2.1 derringer.local" >> /etc/hosts

      sed -i"" -e '$d' /opt/nginx/conf/nginx.conf 
      cat >> /opt/nginx/conf/nginx.conf <<EOC
  # Derringer
  server {
    listen 80;
    server_name derringer.local;
    root /home/smashcon/derringer/public;
    passenger_enabled on;
  } 
}
EOC

      echo '#!/bin/sh

### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO

PATH=/opt/nginx/sbin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/nginx/sbin/nginx
NAME=nginx
DESC=nginx

# Include nginx defaults if available
if [ -f /etc/default/nginx ]; then
  . /etc/default/nginx
fi

test -x $DAEMON || exit 0

set -e

. /lib/lsb/init-functions

test_nginx_config() {
  if $DAEMON -t $DAEMON_OPTS >/dev/null 2>&1; then
    return 0
  else
    $DAEMON -t $DAEMON_OPTS
    return $?
  fi
}

case "$1" in
  start)
    echo -n "Starting $DESC: "
    test_nginx_config
    # Check if the ULIMIT is set in /etc/default/nginx
    if [ -n "$ULIMIT" ]; then
      # Set the ulimits
      ulimit $ULIMIT
    fi
    start-stop-daemon --start --quiet --pidfile /var/run/$NAME.pid \
        --exec $DAEMON -- $DAEMON_OPTS || true
    echo "$NAME."
    ;;

  stop)
    echo -n "Stopping $DESC: "
    start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid \
        --exec $DAEMON || true
    echo "$NAME."
    ;;

  restart|force-reload)
    echo -n "Restarting $DESC: "
    start-stop-daemon --stop --quiet --pidfile \
        /var/run/$NAME.pid --exec $DAEMON || true
    sleep 1
    test_nginx_config
    start-stop-daemon --start --quiet --pidfile \
        /var/run/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS || true
    echo "$NAME."
    ;;

  reload)
    echo -n "Reloading $DESC configuration: "
    test_nginx_config
    start-stop-daemon --stop --signal HUP --quiet --pidfile /var/run/$NAME.pid \
        --exec $DAEMON || true
    echo "$NAME."
    ;;

  configtest|testconfig)
    echo -n "Testing $DESC configuration: "
    if test_nginx_config; then
      echo "$NAME."
    else
      exit $?
    fi
    ;;

  status)
    status_of_proc -p /var/run/$NAME.pid "$DAEMON" nginx && exit 0 || exit $?
    ;;
  *)
    echo "Usage: $NAME {start|stop|restart|reload|force-reload|status|configtest}" >&2
    exit 1
    ;;
esac

exit 0' > /etc/init.d/nginx
    chmod 755 /etc/init.d/nginx
    update-rc.d nginx defaults

EOS

  # Derringer setup
  git clone git://github.com/smashcon/derringer.git
  cd ~/derringer
  bundle

  vi config/database.rb

  mysql -u root -p <<EOM
    CREATE DATABASE IF NOT EXISTS derringer;
    CREATE DATABASE IF NOT EXISTS chiki;
    GRANT ALL ON derringer.* TO 'smashcon'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
    GRANT ALL ON chiki.* TO 'smashcon'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';
    FLUSH PRIVILEGES;
EOM

  alias be="bundle exec"
  export PADRINO_ENV=production
  export RACK_ENV=production
  be padrino rake ar:migrate
  be padrino rake smashcon:db:grab_dump_from_source # [optional_remote_name_here]
  be padrino rake smashcon:db:convert_from_chiki

  be rake couchdb:db:admin[smashcon,$COUCHDB_PASSWORD]
  be rake couchdb:db:create[smashcon,$COUCHDB_PASSWORD]
  be rake couchdb:db:replication[smashcon,$COUCHDB_PASSWORD] hosts="$HOSTS"

  sudo -s <<EOS
    # Kick it off.
    /etc/init.d/nginx start
    
    # Install Chrome
    cd ~
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
    dpkg -i google-chrome-stable_current_i386.deb
    apt-get -f install
EOS

EOF

done
```
