#!/bin/bash
POSTGRES_VERSION=$1
MAX_CONNECTIONS=$2
if [ $POSTGRES_VERSION -ne 14 ]; then
  sudo apt-get install curl ca-certificates gnupg
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list > /dev/null
  sudo apt-get remove postgresql postgresql-14
  sudo apt-get update
  sudo apt-get install postgresql-$POSTGRES_VERSION postgresql-contrib-$POSTGRES_VERSION
  sudo sed -i 's/port = 5433/port = 5432/' /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf
fi
sudo bash -c 'echo fsync=off >> /etc/postgresql/'$POSTGRES_VERSION'/main/postgresql.conf'
sudo bash -c 'echo synchronous_commit=off >> /etc/postgresql/'$POSTGRES_VERSION'/main/postgresql.conf'
sudo bash -c 'echo full_page_writes=off >> /etc/postgresql/'$POSTGRES_VERSION'/main/postgresql.conf'
sudo bash -c 'echo bgwriter_lru_maxpages=0 >> /etc/postgresql/'$POSTGRES_VERSION'/main/postgresql.conf'
sudo sed -i 's/md5/trust/' /etc/postgresql/$POSTGRES_VERSION/main/pg_hba.conf
sudo sed -i 's/peer/trust/' /etc/postgresql/$POSTGRES_VERSION/main/pg_hba.conf
sudo sed -i -e "s/^max_connections = 100.*$/max_connections = $MAX_CONNECTIONS/" /etc/postgresql/$POSTGRES_VERSION/main/postgresql.conf
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo systemctl start postgresql
