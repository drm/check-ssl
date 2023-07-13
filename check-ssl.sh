#!/usr/bin/env bash

## Usage:
## 
##	[DELTA=x] ./check-ssl.sh DOMAIN [IP]
##
## Where:
##
##	DOMAIN 		is the common name you wish to check
##	IP 		is the server to connect to.
## 
## Options:
##
##	DELTA		The time delta to verify the expiry time in (seconds)
##	DEBUG		Set to a non-empty value will run the script `set -x`
##	GREP_FLAGS	Override the default --color grep flag.

set -euo pipefail

if [ "${DEBUG:-}" != "" ]; then
	set -x
fi

DELTA="${DELTA:-604800}" # 1 week
GREP_FLAGS="${GREP_FLAGS-"--color"}" # 1 week

lookup() {
	dig +short "$1" | tail -1
}

check() {
	local fqdn="$1"
	local ip="${2:-}"
	if [ "$ip" == "" ]; then
	 	ip="$(lookup "$fqdn")"
	fi
	echo "$fqdn @ $ip"

	echo | openssl \
		s_client \
		-verify_hostname $fqdn \
		-servername $fqdn \
		-connect $ip:443 \
		2>/dev/null | ( grep "mismatch" || echo "Hostname $fqdn OK" )
	echo | openssl \
			s_client \
			-servername $fqdn \
			-connect $ip:443 \
			2>/dev/null \
		| openssl x509 -enddate -checkend $DELTA 
	echo ""
}


check $@ | grep $GREP_FLAGS -e 'will expire' $GREP_FLAGS -e 'mismatch' -e '^'
