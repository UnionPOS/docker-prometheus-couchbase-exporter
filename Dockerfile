FROM unionpos/ubuntu:16.04

ENV VERSION 0.8.1
ENV DOWNLOAD_FILE "couchbase_exporter-${VERSION}-linux-amd64.tar.gz"
ENV DOWNLOAD_URL "https://github.com/blakelead/couchbase_exporter/releases/download/${VERSION}/${DOWNLOAD_FILE}"
ENV DOWNLOAD_SHA 94330b84fd64c4ebb588e33b2b4fb423e834582a2ddd5c0c3b372a7003c5e9b5

ENV CB_EXPORTER_LISTEN_ADDR=:9091            \
    CB_EXPORTER_TELEMETRY_PATH=/metrics      \
    CB_EXPORTER_DB_URI=http://127.0.0.1:8091 \
    CB_EXPORTER_DB_USER=admin                \
    CB_EXPORTER_DB_PASSWORD=password         \
    CB_EXPORTER_LOG_LEVEL=info               \
    CB_EXPORTER_LOG_FORMAT=text              \
    CB_EXPORTER_SCRAPE_CLUSTER=true          \
    CB_EXPORTER_SCRAPE_NODE=true             \
    CB_EXPORTER_SCRAPE_BUCKET=true           \
    CB_EXPORTER_SCRAPE_XDCR=true

RUN set -ex \
    && buildDeps=' \
    ca-certificates \
    wget \
    ' \
    && apt-get update -qq \
    && apt-get install -qq -y $buildDeps \
    && wget -O "$DOWNLOAD_FILE" "$DOWNLOAD_URL" \
    && apt-get autoremove -qq -y $buildDeps && rm -rf /var/lib/apt/lists/* \
    && echo "${DOWNLOAD_SHA} *${DOWNLOAD_FILE}" | sha256sum -c - \
    && tar xfvz "$DOWNLOAD_FILE" -C "/tmp" \
    && mv "/tmp/couchbase_exporter" /bin/couchbase_exporter \
    && mv "/tmp/metrics" /bin/metrics \
    && rm /tmp/LICENSE.txt \
    && rm "$DOWNLOAD_FILE"

CMD couchbase_exporter


