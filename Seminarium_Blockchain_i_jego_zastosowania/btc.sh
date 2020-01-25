#!/usr/bin/env bash

NAME="bitcoin-server"

case "$1" in
	run)
		docker run --rm --name "$NAME" -itd ruimarinho/bitcoin-core \
		-printtoconsole \
		-regtest=1
		;;
	stop)
		docker ps -q | xargs docker kill
		;;
	*)
		docker exec --user bitcoin "$NAME" bitcoin-cli -regtest "$@"
esac
