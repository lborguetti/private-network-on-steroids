#!/usr/bin/env nash

import config/weave_route.state

scope stop
weave stop
weave reset --force
weave launch $WEAVE_ROUTER --password $WEAVE_PASSWORD
sleep 30
scope launch
