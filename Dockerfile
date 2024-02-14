FROM ghcr.io/getzola/zola:v0.17.1 as zola

COPY . /website
WORKDIR /website
RUN ["zola", "build"]

FROM ghcr.io/static-web-server/static-web-server:2
WORKDIR /
COPY --from=zola /website/public /public

