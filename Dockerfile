FROM xales/byond:512-latest as byhttp
ENV PATH=/root/cargo/bin:/root/rustup/bin:$PATH\
	CARGO_HOME=/root/cargo\
	RUSTUP_HOME=/root/rustup
RUN apt-get update && apt-get install -y curl git gcc-multilib;\
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init; \
	chmod +x rustup-init; \
	./rustup-init -y --no-modify-path;\
	rm rustup-init;\
	rustup default stable;\
	rustup target add i686-unknown-linux-gnu
RUN git clone https://github.com/Lohikar/byhttp.git || true
WORKDIR /byhttp
RUN mkdir to_copy;\
	cargo build --release --target i686-unknown-linux-gnu;\
	mv -t to_copy target/i686-unknown-linux-gnu/release/libbyhttp.so || true


FROM xales/byond:512-latest as builder
ARG BUILD_ARGS
COPY --from=byhttp /byhttp/to_copy /scav/lib
COPY . /scav
WORKDIR /scav
RUN scripts/dm.sh $BUILD_ARGS scavstation.dme


FROM xales/byond:512-latest as tester_prereqs
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTENV=noninteractive
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
 && apt-get update && apt-get install -y \
    libc6-i386 libgcc1:i386 libstdc++6:i386 uchardet default-jdk \
    make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git unzip

FROM tester_prereqs as pyenv
ENV PYENV_ROOT=/pyenv \
    PYENV_COMMIT="1487135415d53d47fa8e6686ee34111b31b34c24" \
    PYENV_VERSION=3.6.7
ENV PATH=$PATH:$PYENV_ROOT/bin:$PYENV_ROOT/shims
RUN git clone --recursive --shallow-submodules https://github.com/pyenv/pyenv.git $PYENV_ROOT \
 && cd $PYENV_ROOT \
 && export PATH=$PYENV_ROOT/bin:${PATH} \
 && git reset --hard $PYENV_COMMIT \
 && pyenv install $PYENV_VERSION \
 && pyenv global $PYENV_VERSION

FROM pyenv as tester
COPY --from=builder /scav /scav
WORKDIR /scav
ENV TEST=CODE CI=true
ENTRYPOINT ["test/run-test.sh"]


FROM xales/byond:512-latest as spacestation
RUN groupadd -r spaceman \
 && useradd -rm -d /home/spaceman --no-log-init -s /bin/bash -r -g spaceman spaceman \
 && mkdir -p /scav/data /scav/config /scav/lib \
 && chown spaceman:spaceman /scav /scav/config /scav/data /scav/lib
COPY .git/HEAD /scav/.git/HEAD
COPY .git/logs/HEAD /scav/.git/logs/HEAD
COPY --from=builder --chown=spaceman:spaceman /scav/config/example/* /scav/config/
COPY --from=builder --chown=spaceman:spaceman /scav/config/names/* /scav/config/names/
COPY --from=builder --chown=spaceman:spaceman /scav/lib/* /scav/lib/
COPY --from=builder --chown=spaceman:spaceman \
    /scav/scavstation.rsc \
    /scav/scavstation.dmb \
    /scav/
RUN chown -R spaceman:spaceman /home/spaceman /scav
WORKDIR /scav
EXPOSE 8000
VOLUME /scav/data/
VOLUME /scav/config/
ENTRYPOINT ["DreamDaemon", "scavstation.dmb", "8000", "-home", "/scav", "-safe", "-suidself"]
CMD ["-verbose", "-invisible"]
