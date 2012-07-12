
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
    sudo -s <<EOS
      # CouchDB PPA
      apt-add-repository ppa:longsleep/couchdb

      # Pre-requisite libraries, tools and servers
      apt-get update
      apt-get install -y libyaml-dev libssl-dev build-essential git-core curl libcurl4-openssl-dev vim

      # MySQL
      apt-get install -y mysql-server mysql-client libmysqlclient-dev

      # CouchDB
      apt-get install -y couchdb
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
      update-alternatives --config ruby # Prompt: 2
      update-alternatives --config gem  # Prompt: 2

      # Ruby Libraries
      gem install bundler

      # Passenger
      gem install passenger

      # Nginx; follow prompts:
      # 1
      # <enter>
      # <enter>
      passenger-install-nginx-module

      echo -e "\n127.0.2.1 derringer.local" > /etc/hosts

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
  be padrino rake smashcon:db:grab_from_source # [optional_remote_name_here]
  be padrino rake smashcon:db:convert_from_chiki

  be rake couchdb:db:admin[smashcon,$COUCHDB_PASSWORD]
  be rake couchdb:db:create[smashcon,$COUCHDB_PASSWORD]
  be rake couchdb:db:replication[smashcon,$COUCHDB_PASSWORD] hosts="$HOSTS"

  sudo -s <<EOS
    # Kick it off.
    /etc/init.d/nginx start
    # TODO: Is this an autostart?
EOS

EOF

done
```
