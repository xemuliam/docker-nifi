FROM alpine
MAINTAINER Viacheslav Kalashnikov <xemuliam@gmail.com>
LABEL VERSION="1.0.0" \
    RUN="docker run -d -p 8080:8080 xemuliam/docker-nifi"

ENV DIST_MIRROR http://mirror.cc.columbia.edu/pub/software/apache/nifi
ENV NIFI_HOME /opt/nifi
ENV VERSION 1.0.0

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.4/community/" >> /etc/apk/repositories &&\
  apk update && apk add --upgrade openjdk8 curl && \
  mkdir /opt && \
  curl -s ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C /opt  && \
  mv /opt/nifi-${VERSION} ${NIFI_HOME} && \
  sed -i '/nifi.flow/s#conf/#flow/#g' ${NIFI_HOME}/conf/nifi.properties && \
  mkdir ${NIFI_HOME}/flow && \
  apk del curl && \
  rm -rf /var/cache/apk/*

ADD start_nifi.sh /${NIFI_HOME}/

EXPOSE 443 8080
VOLUME ["/opt/certs", "${NIFI_HOME}/flowfile_repository", "${NIFI_HOME}/content_repository", "${NIFI_HOME}/database_repository", "${NIFI_HOME}/content_repository", "${NIFI_HOME}/provenance_repository"]

WORKDIR ${NIFI_HOME}

CMD ["./start_nifi.sh"]
