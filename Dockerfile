FROM gitea/gitea:latest 

RUN apk update && \
    apk add pandoc -X http://dl-cdn.alpinelinux.org/alpine/edge/community;
