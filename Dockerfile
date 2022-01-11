FROM --platform=$BUILDPLATFORM golang:1.16 AS builder

LABEL org.opencontainers.image.source=https://github.com/shipperizer/go-json-server

ARG SKAFFOLD_GO_GCFLAGS
ARG TARGETOS
ARG TARGETARCH

ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GO_BIN=/go/bin/app

WORKDIR /var/app

COPY . .

RUN go build -o $GO_BIN . 

FROM gcr.io/distroless/static:nonroot

LABEL org.opencontainers.image.source=https://github.com/shipperizer/go-json-server

COPY --from=builder /go/bin/app /var/app/app
COPY --from=builder /var/app/example/ /var/app

WORKDIR /var/app

ENTRYPOINT ["/var/app/app"]
