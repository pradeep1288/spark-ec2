#!/bin/bash

# Setup nfs-hdfs
mkdir -p /mnt/nfs-hdfs/logs

# Setup yarn-logs
mkdir -p /mnt/yarn-local
mkdir -p /mnt/yarn-logs

if [[ -e /vol/nfs-hdfs ]] ; then
  chmod -R 755 /vol/nfs-hdfs
fi
