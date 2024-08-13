: '
Script to init multiple postgres databases. Path to place the file:
scp -O -P 2222 services/db/init-multi-db.sh sihuan@192.168.2.72:/share/dockume/db/postgres/pg_multidb

'
#!/bin/bash

set -e
set -u

function create_database() {
	database=$1
  user=$2
  password=$3
  echo "Creating database '$database' with creds: user '$user', password '$password'"
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $user with encrypted password '$password';
    CREATE DATABASE $database;
    ALTER DATABASE $database OWNER TO $user;
EOSQL
}

if [ -n "$POSTGRES_MULTI_DB" ]; then
  echo "Multiple database creation requested: $POSTGRES_MULTI_DB"
  for item in $(echo $POSTGRES_MULTI_DB | tr ',' ' '); do
    db=$(echo $item | awk -F":" '{print $1}')
    user=$(echo $item | awk -F":" '{print $2}')
    pwd=$(echo $item | awk -F":" '{print $3}')
    if [[ -z "$pwd" ]]
    then
      pwd=$user
    fi
    echo "db: $db; user: $user; pass $pwd"
    create_database $db $user $pwd
  done
  echo "Multiple databases created!"
fi
