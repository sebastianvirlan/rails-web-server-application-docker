#!/bin/bash

export SECRET_KEY_BASE=$(rake secret)

APP_ENV="${APP_ENV:-development}"

echo "--- START SERVICES IN $APP_ENV with secret $SECRET_KEY_BASE ---"

source /home/on_run.sh

shutup
rails s -b 0.0.0.0 -e "$APP_ENV"
