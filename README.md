My own Plex Docker image for the Raspberry Pi

# Status
[![Build status](https://travis-ci.org/napnap75/rpi-plex.svg?branch=master)](https://travis-ci.org/napnap75/rpi-plex) [![Image size](https://images.microbadger.com/badges/image/napnap75/rpi-plex.svg)](https://microbadger.com/images/napnap75/rpi-plex "Get your own image badge on microbadger.com") [![Github link](https://assets-cdn.github.com/favicon.ico)](https://github.com/napnap75/rpi-plex) [![Docker hub link](https://www.docker.com/favicon.ico)](https://hub.docker.com/r/napnap75/rpi-plex/)


# Content
This image is based on [armhf/debian](https://hub.docker.com/r/armhf/debian/).

This image contains :

- [Plex](https://github.com/Gandi/gandi.cli) built for the Raspberry Pi by [dev2day](https://www.dev2day.de/typo3/projects/plex-media-server/).
- [QEmu](https://github.com/multiarch/qemu-user-static) to allow the build and run of the images in x86 system (especially Travis CI)
- [Tini](https://github.com/krallin/tini) to properly manage the processes (Tini spawns a single child and wait for it to exit all the while reaping zombies and performing signal forwarding).

# Usage
Use this image to run the Plex Media Server: `docker run -d --name plex --network=host -v <path/to/plex/database>:/var/lib/plexmediaserver -v <path/to/media>:/data napnap75/rpi-plex:latest`
