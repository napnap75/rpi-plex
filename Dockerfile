FROM resin/armv7hf-debian-qemu

RUN [ "cross-build-start" ]

#FROM resin/rpi-raspbian:jessie

# Add Tini to run as PID 1
ENV TINI_VERSION v0.13.2
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf /usr/sbin/tini
RUN chmod +x /usr/sbin/tini
ENTRYPOINT ["/usr/sbin/tini", "--"]

# Load Plex
RUN apt-get update \
	&& apt-get upgrade \
	&& apt-get install wget apt-transport-https \
	&& wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | apt-key add - \
	&& echo "deb https://dev2day.de/pms/ jessie main" >> /etc/apt/sources.list.d/pms.list \
	&& apt-get update \
	&& apt-get install plexmediaserver-installer \
	&& apt-get purge wget apt-transport-https \
	&& apt-get autoremove \
	&& apt-get clean \
	&& rm -fr /var/lib/apt/lists/* \
	&& groupadd -g 1500 plex \
	&& usermod -u 1500 -g plex plex \
	&& chown plex:plex /var/lib/plexmediaserver

# Setup the home volume to hold the server settings
VOLUME /var/lib/plexmediaserver

# Plex server port
EXPOSE 32400 1900/udp 32469 3005 5353/udp 8324 32410/udp 32412/udp 32413/udp 32414/udp

# Add the custom init script
ADD start_pms.sh /usr/bin/start_pms.sh
RUN chmod +x /usr/bin/start_pms.sh
CMD /usr/bin/start_pms.sh

RUN [ "cross-build-end" ] 
