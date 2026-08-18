FROM ubuntu:26.04 AS source

ADD --checksum=sha256:e687fc692dc57abf219e3168d62fb7e3d38b68a4270696779c208fc44917d39e https://github.com/ramboxapp/download/releases/download/v2.7.1/Rambox-2.7.1-linux-x64.deb /tmp/source.deb

RUN dpkg-deb -x /tmp/source.deb /out

FROM ghcr.io/containerpak/gtk3:main

COPY --from=source /out/opt/Rambox /opt/rambox
COPY --from=source /out/usr/share/applications/rambox.desktop /usr/share/applications/com.rambox.Rambox.desktop
COPY --from=source /out/usr/share/icons /usr/share/icons
COPY rambox /usr/bin/rambox

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates desktop-file-utils libasound2t64 \
    libayatana-appindicator3-1 libnss3 libsecret-1-0 libxss1 xdg-utils && \
    for icon in /usr/share/icons/hicolor/*/apps/rambox.png; do \
      mv "$icon" "$(dirname "$icon")/com.rambox.Rambox.png"; \
    done && \
    desktop-file-edit --set-key=Exec --set-value='rambox %U' \
      /usr/share/applications/com.rambox.Rambox.desktop && \
    desktop-file-edit --set-key=Icon --set-value=com.rambox.Rambox \
      /usr/share/applications/com.rambox.Rambox.desktop && \
    desktop-file-edit --add-mime-type=x-scheme-handler/rambox \
      /usr/share/applications/com.rambox.Rambox.desktop && \
    cpak-clean-junk
