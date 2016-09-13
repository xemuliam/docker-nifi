FROM		centos

MAINTAINER	Viacheslav Kalashnikov <xemuliam@gmail.com>

ENV		DIST_MIRROR http://archive.apache.org/dist/nifi
ENV		NIFI_HOME /opt/nifi
ENV		VERSION 0.7.0
ENV		BANNER_TEXT Docker-Nifi-1.0.0
ENV		INSTANCE_ROLE single-node
ENV		NODES_LIST NA
ENV		MYID NA

RUN yum update -y &&\
  yum install -y java-1.8.0-openjdk-devel tar && \
  mkdir -p /opt/nifi && \
  curl ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} --strip-components=1 && \
  sed -i '/java.arg.1/a java.arg.15=-Djava.security.egd=file:/dev/./urandom' ${NIFI_HOME}/conf/bootstrap.conf && \
  sed -i '/nifi.flow/s#conf/#flow/#g' ${NIFI_HOME}/conf/nifi.properties && \
  mkdir ${NIFI_HOME}/flow && \
  yum clean all

ADD start_nifi.sh /${NIFI_HOME}/

EXPOSE 8080 8081 10001

VOLUME ["/opt/datafiles","/opt/scriptfiles","/opt/certs", "${NIFI_HOME}/logs","${NIFI_HOME}/flowfile_repository", "${NIFI_HOME}/database_repository", "${NIFI_HOME}/content_repository", "${NIFI_HOME}/provenance_repository"]

WORKDIR ${NIFI_HOME}
RUN chmod +x ./start_nifi.sh
CMD ["./start_nifi.sh"]
