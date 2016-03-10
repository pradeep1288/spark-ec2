#!/bin/bash

NFS_HDFS=/root/nfs-hdfs

pushd /root/spark-ec2/nfs-hdfs > /dev/null
source ./setup-slave.sh

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/nfs-hdfs/setup-slave.sh" & sleep 0.3
done
wait

/root/spark-ec2/copy-dir $NFS_HDFS/conf

echo "nfs HDFS installed, won't start by default..."

popd > /dev/null
