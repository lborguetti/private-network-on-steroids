#!/usr/bin/env bash

set -e

servers=($(/opt/bin/weave dns-lookup app))

if test -n ${#servers[*]} ; then
    for ((i=0;i<${#servers[*]};i++)); do
	echo "server app${i} ${servers[$i]}:8080 resolvers dns check inter 1000"
    done
fi

docker kill -s HUP haproxy
