#!/bin/bash

echo "Run linting..."
luacheck lua --globals [vim, _TEST]

echo "Run tests..."
pushd lua
busted
popd
