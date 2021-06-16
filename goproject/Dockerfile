FROM golang:1.16-alpine AS builder
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -o app .

FROM alpine:3.13.5
COPY --from=builder /build/app .
ENTRYPOINT ["./app"]
CMD ["3000"]
