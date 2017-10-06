FROM arm32v7/debian:jessie

# Install QEmu to be able to build this image in Travis CI
COPY qemu-arm-static /usr/bin/qemu-arm-static

# Add Tini to run as PID 1
ENV TINI_VERSION v0.13.2
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf /usr/sbin/tini
RUN chmod +x /usr/sbin/tini
ENTRYPOINT ["/usr/sbin/tini", "--"]

# Load Plex
RUN apt-get update \
	&& apt-get -y upgrade \
	&& apt-get -y install wget apt-transport-https \
	&& wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | apt-key add - \
	&& echo "deb https://dev2day.de/pms/ jessie main" >> /etc/apt/sources.list.d/pms.list \
	&& apt-get update \
	&& apt-get -y install plexmediaserver-installer \
	&& apt-get -y purge wget apt-transport-https \
	&& apt-get -y autoremove \
	&& apt-get -y clean \
	&& rm -fr /var/lib/apt/lists/* \
	&& groupmod -g 1500 plex \
	&& usermod -u 1500 -g plex plex \
	&& chown plex:plex /var/lib/plexmediaserver

# Setup the home volume to hold the server settings
VOLUME /var/lib/plexmediaserver

# Plex server port
EXPOSE 32400 1900/udp 32469 3005 5353/udp 8324 32410/udp 32412/udp 32413/udp 32414/udp

# Add the custom init script
ADD start_pms.sh /usr/bin/start_pms.sh
CMD /usr/bin/start_pms.sh

# Add an health check
ADD healthcheck.sh /usr/bin/healthcheck.sh
HEALTHCHECK --interval=200s --timeout=100s CMD /usr/bin/healthcheck.sh || exit 1
