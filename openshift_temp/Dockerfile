FROM openshift/origin-haproxy-router

RUN yum install -y golang && yum clean all

ENV GOPATH /go

RUN go get github.com/bradfitz/runsit

WORKDIR $GOPATH/src/github.com/bradfitz/runsit

ENV PATH $PATH:$GOROOT/bin

RUN go install github.com/bradfitz/runsit/jsonconfig && \
    go build -x -o runsit && \
    mv $GOPATH/bin/runsit /usr/sbin/runsit


RUN mkdir -p /etc/runsit

EXPOSE 4762
#ENTRYPOINT ["/usr/sbin/runsit"]
ENTRYPOINT ["/bin/bash"]
