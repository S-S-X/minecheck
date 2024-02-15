#syntax=docker/dockerfile:1.2

FROM akorn/luarocks:lua5.4-alpine AS builder

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	dumb-init gcc libc-dev git

RUN git clone --depth 1 --branch minetest-builtin https://github.com/BuckarooBanzay/luacheck.git /src
WORKDIR /src
RUN luarocks --tree /pkgdir/usr/local make
RUN find /pkgdir -type f -exec sed -i -e 's!/pkgdir!!g' {} \;

FROM akorn/lua:5.4-alpine AS final

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
	dumb-init

COPY --from=builder /pkgdir /
RUN luacheck --version

WORKDIR /data

ENTRYPOINT ["luacheck", "--no-cache"]