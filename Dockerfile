FROM golang:1.21.1-alpine as builder

#atualização do alpine
RUN apk update && apk add --no-cache build-base

#checar se upx está disponível, caso não, seta true para seguir com as layers
RUN apk add upx || true 

WORKDIR /app

COPY ./desafio-docker.go .

RUN CGO_ENABLED=0 GOOS=linux \
  go build -a -installsuffix cgo -ldflags="-s -w" -o desafio_docker ./desafio-docker.go && upx desafio_docker || true

# inicialização de container vazio
FROM scratch as main
WORKDIR /root/

#copia os arquivos do builder para o container
COPY --from=builder /app/desafio_docker .
CMD ["./desafio_docker"]
