# builder image
FROM golang:1.19-alpine3.16 as builder
RUN mkdir /build
WORKDIR /build
COPY go.* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o prometheus-example .

# generate clean, final image for end users
FROM alpine:3.16
COPY --from=builder /build/prometheus-example .

# executable
ENTRYPOINT [ "./prometheus-example" ]