#!/bin/bash

cd /src/learninglocker/
pm2 start pm2/all.json
cd /src/xapi-service/
pm2 start pm2/xapi.json
pm2 logs
