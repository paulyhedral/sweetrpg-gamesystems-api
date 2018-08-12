#!/bin/bash

docker run --name sweetrpg-gamesystem-postgres -e POSTGRES_DB=gamesystem \
  -e POSTGRES_USER=sweetrpg -e POSTGRES_PASSWORD=password \
  -p 5432:5432 -d postgres
