#!/bin/sh
set -e

# Bundle the Equicord browser extension into the Neutron build tree.
"$(dirname "$0")/scripts/integrate-equicord.sh"

cd neutron
python configurator.py --config-file=../resources/config.json -b "$@"
