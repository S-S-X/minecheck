FROM alpine:latest as base

USER root
ENV USER=root

# Install required tools, Lua, luasocket and luacov
RUN apk add --no-cache build-base git luarocks5.1 lua5.1-sec

# I'm so sorry about this but I believe you can handle it
RUN rm -fv /usr/bin/lua /usr/bin/luac /usr/bin/luac5.1 /usr/bin/lua5.1 \
	&& ln -sT luajit /usr/bin/lua \
	&& ln -sT luajit /usr/bin/lua5.1 \
	&& ln -sT luajit /usr/bin/luac5.1 \
	&& ln -sT luajit /usr/bin/luac \
	&& apk del --no-cache -f lua-dev \
	&& apk add --no-cache luajit luajit-dev

################################
# Build
FROM base as build

# Build and install luacheck
RUN mkdir /build \
	&& cd /build \
	&& git clone --depth 1 --branch minetest-builtin https://github.com/BuckarooBanzay/luacheck.git \
	&& cd luacheck \
	&& luarocks-5.1 make

################################
# Cleanup
FROM alpine:latest

COPY --from=build /usr/local /usr/local

# Just nice to have but wont be default
RUN adduser -D luacheck

# Stuff needed to actually run it
RUN apk add --no-cache luajit
RUN ln -sT /usr/bin/luajit /usr/bin/lua5.1
RUN ln -sT /usr/bin/luajit /usr/bin/lua

WORKDIR /repo
ENTRYPOINT ["luacheck", "--std", "minetest+max"]
CMD ["--config", ".luacheckrc", "."]