#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

export PYTHONPATH=$SCRIPTPATH/venv/lib/python3.8/site-packages/:$PYTHONPATH

python3 -m pyls -vv --log-file /tmp/pyls.log "$@"
