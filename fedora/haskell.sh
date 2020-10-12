#!/usr/bin/env bash
#
# haskell stack

sudo yum install -y libffi-devel gmp-devel zlib-devel

# https://docs.haskellstack.org/en/stable/README/
curl -sSL https://get.haskellstack.org/ | sudo sh
