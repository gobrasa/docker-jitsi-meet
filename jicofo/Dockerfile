ARG JITSI_REPO=gobrasa
FROM ${JITSI_REPO}/base-java

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jicofo && \
	apt-cleanup

COPY rootfs/ /

VOLUME /config

