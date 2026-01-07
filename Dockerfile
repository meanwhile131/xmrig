FROM alpine AS builder
RUN apk add --no-cache git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers
WORKDIR /app
COPY . .
RUN cd scripts && ./build_deps.sh
RUN cmake -B build -DXMRIG_DEPS=scripts/deps -DBUILD_STATIC=ON -DARM_TARGET=7
RUN cd build && make -j$(nproc)

FROM scratch
COPY --from=builder /app/build/xmrig /
ENTRYPOINT [ "/xmrig" ]