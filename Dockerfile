FROM arm64v8/openjdk:jre-alpine

COPY qemu-aarch64-static /usr/bin/
COPY qemu-arm-static /usr/bin/
SHELL ["/bin/sh", "-c"]
MAINTAINER PlusMinus <piddlpiddl@gmail.com>

# Create directory, and start JD2 for the initial update and creation of config files.
RUN mkdir -p /opt/JDownloader/libs && \
    apk add --no-cache --quiet tini su-exec shadow ffmpeg jq libstdc++ && \
    apk add wget  --virtual .build-deps && \
    wget -O /opt/JDownloader/JDownloader.jar --user-agent="https://hub.docker.com/r/plusminus/jdownloader2-headless/" http://installer.jdownloader.org/JDownloader.jar && \
    java -Djava.awt.headless=true -jar /opt/JDownloader/JDownloader.jar


# Beta sevenzipbindings and entrypoint
COPY common/* /opt/JDownloader/



ENTRYPOINT ["tini", "-g", "--", "/opt/JDownloader/entrypoint.sh"]
# Run this when the container is started
CMD ["java", "-Djava.awt.headless=true", "-jar", "/opt/JDownloader/JDownloader.jar"]