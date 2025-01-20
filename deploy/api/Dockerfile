FROM amazonlinux:latest

WORKDIR /api
COPY ./api.go .
RUN chmod 777 api.go
RUN yum update -y && \
    yum install -y --skip-broken curl golang && \
    go build ./api.go
RUN useradd jncuser
USER jncuser
EXPOSE 8080

CMD [ "./api" ]