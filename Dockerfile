FROM public.ecr.aws/docker/library/golang:1.21.4 as base
WORKDIR /app/
ENV GOOS="linux"
ENV CGO_ENABLED=0

FROM base as dev
WORKDIR /app/
RUN curl -sSfL https://raw.githubusercontent.com/cosmtrek/air/master/install.sh | sh -s -- -b $(go env GOPATH)/bin
ENTRYPOINT ["air"]

FROM base as builder
ADD . /app/
WORKDIR /app/
RUN CGO_ENABLE=0 GOOS=linux go build -a -installsuffix cgo -o pamm-backend .

FROM public.ecr.aws/docker/library/alpine:latest
RUN apt-get update \
    && apt-get install --no-cache \
    ca-certificates \
    curl \
    tzdata \
    && update-ca-certificates
WORKDIR /app/
COPY --from=builder /app/pamm-backend .
ENTRYPOINT ["/app/pamm-backend"]