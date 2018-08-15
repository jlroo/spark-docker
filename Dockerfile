# the base image is a trusted java build (https://registry.hub.docker.com/_/java/)

FROM centos:7

MAINTAINER jrodriguezorjuela@luc.edu

####installing [software-properties-common] so that we can use [apt-add-repository] to install Java8
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y update
RUN yum -y install wget 
RUN yum -y install java-1.8.0-openjdk
RUN yum -y install java-1.8.0-openjdk-devel
RUN yum install -y python36u python36u-libs python36u-devel python36u-pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install supervisor
RUN pip3.6 install ipython
RUN echo_supervisord_conf > /etc/supervisord.conf

####downloading & unpacking Spark 2.2.1 [prebuilt for Hadoop 2.6+ and scala 2.10]
RUN wget http://apache.cs.utah.edu/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz
RUN tar -xzf spark-2.3.1-bin-hadoop2.7.tgz
RUN mv spark-2.3.1-bin-hadoop2.7 /opt/spark
RUN rm -rf spark-2.3.1-bin-hadoop2.7.tgz get-pip.py

#####adding conf files [to be used by supervisord for running spark master/worker]
COPY master.conf /opt/conf/master.conf
COPY worker.conf /opt/conf/worker.conf
RUN cp /opt/spark/conf/spark-env.sh.template /opt/spark/conf/spark-env.sh
RUN echo "export PYSPARK_PYTHON=python3.6" >> /opt/spark/conf/spark-env.sh
RUN echo "export PYSPARK_DRIVER_PYTHON=ipython" >> /opt/spark/conf/spark-env.sh
RUN rm -rf /opt/spark/conf/spark-env.sh.template

#######exposing port 8080 for spark master UI
EXPOSE 8080

#default command: running an interactive spark shell in the local mode
CMD ["spark-shell", "--master", "local[*]"]


RUN rm -rf /opt/spark/conf/spark-env.sh.template
RUN echo "export PYSPARK_PYTHON=python3.6" >> /opt/spark/conf/spark-env.sh
RUN echo "export PYSPARK_DRIVER_PYTHON=ipython" >> /opt/spark/conf/spark-env.sh