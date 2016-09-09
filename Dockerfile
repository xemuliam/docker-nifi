FROM		alpine

MAINTAINER	Viacheslav Kalashnikov <xemuliam@gmail.com>

ENV		DIST_MIRROR http://archive.apache.org/dist/nifi
ENV		NIFI_HOME /opt/nifi
ENV		VERSION 1.0.0
ENV		BANNER_TEXT Docker-Nifi
ENV		INSTANCE_ROLE single-node
ENV		ZOOKEEPER_CONNECT NA
ENV		MYID NA

RUN echo "http://dl-4.alpinelinux.org/alpine/latest-stable/community/" >> /etc/apk/repositories &&\
	apk update && apk add --upgrade openjdk8 curl && \
	mkdir /opt && \
	curl -s ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C /opt  && \
	mv /opt/nifi-${VERSION} ${NIFI_HOME} && \
	sed -i '/nifi.flow/s#conf/#flow/#g' ${NIFI_HOME}/conf/nifi.properties && \
	mkdir ${NIFI_HOME}/flow && \
	apk del curl && \
	rm -rf /var/cache/apk/*

ADD start_nifi.sh /${NIFI_HOME}/

EXPOSE 8080 8081 10001

VOLUME ["/opt/datafiles","/opt/scriptfiles","/opt/certs", "${NIFI_HOME}/logs","${NIFI_HOME}/flowfile_repository", "${NIFI_HOME}/database_repository", "${NIFI_HOME}/content_repository", "${NIFI_HOME}/provenance_repository"]

WORKDIR ${NIFI_HOME}

RUN chmod +x ./start_nifi.sh
CMD ["./start_nifi.sh"]
