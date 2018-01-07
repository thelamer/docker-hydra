FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	openjdk8-jre \
	unzip && \
 echo "**** install hydra2 ****" && \
 HYDRA_VER=$(curl -sX GET "https://api.github.com/repos/theotherp/nzbhydra2/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 HYDRA2_VER=${HYDRA_VER#v} && \
 curl -o \
 /tmp/hydra2.zip -L \
	"https://github.com/theotherp/nzbhydra2/releases/download/v${HYDRA2_VER}/nzbhydra2-${HYDRA2_VER}-linux.zip" && \
 mkdir -p /app/hydra2 && \
 unzip /tmp/hydra2.zip -d /app/hydra2 && \
 mv /app/hydra2/lib/core-${HYDRA2_VER}-exec.jar /app/hydra2/lib/core-exec.jar && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 5075
VOLUME /config /downloads
