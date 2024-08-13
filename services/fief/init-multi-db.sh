: '
Script to init multiple postgres databases. Path to place the file:
scp services/fief/init-multi-db.sh sihuan@xwick.ru:/share/dockume/db/postgres/pg_multidb
'
#!/bin/bash

set -e
set -u

function create_database() {
	database=$1
  password=$2
  echo "Creating user and database '$database' with password '$password'"
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $database with encrypted password '$password';
    CREATE DATABASE $database;
    ALTER DATABASE $database OWNER TO $database;
EOSQL
}

if [ -n "$POSTGRES_MULTI_DB" ]; then
  echo "Multiple database creation requested: $POSTGRES_MULTI_DB"
  for item in $(echo $POSTGRES_MULTI_DB | tr ',' ' '); do
    db=$(echo $item | awk -F":" '{print $1}')
    user=$(echo $item | awk -F":" '{print $2}')
    pswd=$(echo $item | awk -F":" '{print $3}')
    if [[ -z "$pswd" ]]
    then
      pswd=$user
    fi
    echo "user is $user and pass is $pswd"
    create_database $user $pswd
  done
  echo "Multiple databases created!"
fi
