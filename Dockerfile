FROM gitea/gitea:latest 

RUN apk update && \
    apk add pandoc -X http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    apk add npm chromium && \
    npm install --global mermaid-filter  @mermaid-js/mermaid-cli puppeteer && \
    sed -i 's;var puppeteerConfig = path.join(folder, ".puppeteer.json");var puppeteerConfig = process.env.PUPPETEER_CFG || path.join(folder, ".puppeteer.json");' /usr/local/lib/node_modules/mermaid-filter/index.js;

ENV PUPPETEER_CFG /data/gitea/conf/.puppeteer.json
ADD config/.puppeteer.json /data/gitea/conf/.;
