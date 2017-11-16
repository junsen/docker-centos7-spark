FROM centos:centos7
MAINTAINER junsen "panjunsen@patsnap.com"

RUN yum -y update \
	&& yum -y groupinstall 'Development Tools' \
    && yum clean all

CMD "/bin/bash"