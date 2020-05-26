#!/bin/bash

export $(cat .env | xargs)
puma  -C config/puma-debug.rb

