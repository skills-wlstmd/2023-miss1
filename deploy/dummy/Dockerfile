FROM amazonlinux:latest

WORKDIR /dummy
COPY ./dummy.go .
RUN chmod 777 dummy.go
RUN yum update -y && \
    yum install -y --skip-broken curl golang && \
    go build ./dummy.go
RUN useradd jncuser
USER jncuser
EXPOSE 8080

CMD [ "./dummy" ]