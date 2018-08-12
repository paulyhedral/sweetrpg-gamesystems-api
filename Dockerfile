FROM swift:4.1 AS build
LABEL maintainer="Paul Schifferer <paul@schifferers.net>"

RUN apt update && apt dist-upgrade -y # && \
#     /bin/bash -c "$(wget -qO- https://apt.vapor.sh)" && \
#     apt install -y vapor && \
#     swift --version && \
#     vapor version

ARG GITHUBKEY

ADD . /build
WORKDIR /build
RUN mkdir $HOME/.ssh && echo "${GITHUBKEY}" > $HOME/.ssh/id_rsa && chmod 400 $HOME/.ssh/id_rsa
RUN ls -l $HOME/.ssh
RUN swift build --verbose --disable-sandbox

FROM swift:4.1 AS deploy

WORKDIR /app
COPY --from=build /build/.build /app

CMD [ "./App" ]
