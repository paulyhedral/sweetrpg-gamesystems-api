#!/bin/bash

set -e
set -o pipefail

export GITHUBKEY="$(cat ~/.ssh/id_rsa)"
docker-compose up -d
