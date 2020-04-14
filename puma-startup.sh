#!/bin/bash

export $(cat .env-hybrid | xargs)
puma  -C config/puma.rb

