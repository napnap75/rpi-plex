#!/bin/bash

# Remove PID file if it was not properly removed on the last stop
PLEX_PID="/home/Library/Application Support/Plex Media Server/plexmediaserver.pid"
if [ -f "$PLEX_PID" ]; then
  rm "$PLEX_PID"
fi

# Run Plex as the plex user
su -l plex -c "/usr/sbin/start_pms"
