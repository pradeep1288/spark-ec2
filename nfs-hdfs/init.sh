#!/bin/bash

pushd /root > /dev/null

if [ -d "nfs-hdfs" ]; then
  echo "nfs HDFS seems to be installed. Exiting."
  return 0
fi

case "$HADOOP_MAJOR_VERSION" in
  1)
    wget http://s3.amazonaws.com/spark-related-packages/hadoop-1.0.4.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-1.0.4.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-1.0.4/ nfs-hdfs/
    cp /root/hadoop-native/* /root/nfs-hdfs/lib/native/
    ;;
  2)
    wget http://apache.arvixe.com/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.7.2/ nfs-hdfs/

    # Have single conf dir
    rm -rf /root/nfs-hdfs/etc/hadoop/
    ln -s /root/nfs-hdfs/conf /root/nfs-hdfs/etc/hadoop
    cp /root/hadoop-native/* /root/nfs-hdfs/lib/native/
    ;;
  yarn)
    wget http://apache.arvixe.com/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
    echo "Unpacking Hadoop"
    tar xvzf hadoop-*.tar.gz > /tmp/spark-ec2_hadoop.log
    rm hadoop-*.tar.gz
    mv hadoop-2.7.2/ nfs-hdfs/

    # Have single conf dir
    rm -rf /root/nfs-hdfs/etc/hadoop/
    ln -s /root/nfs-hdfs/conf /root/nfs-hdfs/etc/hadoop
    cp /root/hadoop-nfs-connector-* /root/nfs-hdfs/share/hadoop/common/lib/
    cp /root/hadoop-nfs-2.7* /root/nfs-hdfs/share/hadoop/common/hadoop-nfs-2.7.2.jar

    ;;

  *)
     echo "ERROR: Unknown Hadoop version"
     return 1
esac
/root/spark-ec2/copy-dir /root/nfs-hdfs

popd > /dev/null
