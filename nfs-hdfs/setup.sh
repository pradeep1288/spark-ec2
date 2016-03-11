#!/bin/bash

NFS_HDFS=/root/nfs-hdfs

pushd /root/spark-ec2/nfs-hdfs > /dev/null
source ./setup-slave.sh

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS root@$node "/root/spark-ec2/nfs-hdfs/setup-slave.sh" & sleep 0.3
done
wait

/root/spark-ec2/copy-dir $NFS_HDFS/conf

echo "nfs HDFS installed, starting services..."

case "$HADOOP_MAJOR_VERSION" in
  1)
    $NFS_HDFS/bin/start-dfs.sh
    ;;
  2)
    $NFS_HDFS/sbin/start-dfs.sh
    ;;
  yarn) 
    echo "Starting YARN"
    $NFS_HDFS/sbin/start-yarn.sh
    echo "Starting history server"
    `$NFS_HDFS/sbin/mr-jobhistory-daemon.sh start historyserver`
    ;;
  *)
     echo "ERROR: Unknown Hadoop version"
     return -1
esac

popd > /dev/null
