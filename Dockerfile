FROM centos:centos7
MAINTAINER junsen "panjunsen@patsnap.com"

#SPARK
ENV SPARK_PROFILE 2.1
ENV SPARK_VERSION 2.1.2
ENV HADOOP_PROFILE 2.7
ENV HADOOP_VERSION 2.7.0

RUN yum -y update \
	&& yum -y groupinstall 'Development Tools' \
	&& yum install -y java-1.8.0-openjdk.x86_64 \	
    && yum clean all
RUN yum install -y  \
	bzip2 \
	tar \
	git \
	unzip \
	&& \
	yum clean all

RUN curl -sL --retry 3 \
	"http://mirror.bit.edu.cn/apache/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE.tgz" \
	| gunzip \
	| tar x -C /opt/ \
	&& ln -s /opt/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE /opt/spark

# SCRIPTS AND ENVIRONMENTAL VARS

ADD scripts/start-master.sh /start-master.sh
ADD scripts/start-worker /start-worker.sh
ADD scripts/spark-shell.sh  /spark-shell.sh
ADD scripts/spark-defaults.conf /spark-defaults.conf
ADD scripts/remove_alias.sh /remove_alias.sh
ENV SPARK_HOME /opt/spark

ENV SPARK_MASTER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"
ENV SPARK_WORKER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"

ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_WORKER_PORT 8888
ENV SPARK_WORKER_WEBUI_PORT 8081

EXPOSE 8080 7077 8888 8081 4040 7001 7002 7003 7004 7005 7006