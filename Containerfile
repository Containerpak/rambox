FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/rambox"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates desktop-file-utils libasound2t64 \
    libayatana-appindicator3-1 libatspi2.0-0 libnotify4 libnss3 libsecret-1-0 \
    libuuid1 libxss1 libxtst6 xdg-utils && \
    cpak-clean-junk

COPY rambox /usr/local/bin/rambox-cpak
COPY com.rambox.Rambox.cpak.desktop /usr/share/applications/com.rambox.Rambox.cpak.desktop
