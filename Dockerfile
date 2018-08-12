FROM swift:4.1 AS build
LABEL maintainer="Paul Schifferer <paul@schifferers.net>"

ARG GITHUBKEY

RUN apt update && apt dist-upgrade -y

ADD . /build
WORKDIR /build
RUN mkdir $HOME/.ssh
RUN ssh-keyscan -t rsa github.com 2>&1 > /root/.ssh/known_hosts
RUN mv git_config $HOME/.ssh/config && \
    echo "${GITHUBKEY}" > $HOME/.ssh/id_rsa && \
    chmod 400 $HOME/.ssh/id_rsa
RUN swift build

FROM swift:4.1 AS runtime

ADD Public /app/Public
WORKDIR /app
COPY --from=build /build/.build/x86_64-unknown-linux/debug/Run /app

EXPOSE 8080
CMD [ "/app/Run" ]
