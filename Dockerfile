FROM gitea/gitea:latest 

#    apk add pandoc -X http://dl-cdn.alpinelinux.org/alpine/edge/community && \
RUN apk update && \
    apk add npm chromium && \
    npm install --global mermaid-filter  @mermaid-js/mermaid-cli puppeteer katex && \
    sed -i 's;var puppeteerConfig = path.join(folder, ".puppeteer.json");var puppeteerConfig = process.env.PUPPETEER_CFG || path.join(folder, ".puppeteer.json");' /usr/local/lib/node_modules/mermaid-filter/index.js;

ENV PUPPETEER_CFG /data/gitea/conf/.puppeteer.json
ADD config/.puppeteer.json /data/gitea/conf/.;
RUN wget -c https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz -O - | tar -xz; \
        ln -s "$(pwd)"/pandoc-2.19.2/bin/pandoc /usr/bin/pandoc;

