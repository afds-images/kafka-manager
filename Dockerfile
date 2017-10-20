FROM openjdk:8-alpine

ENV ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.3.14

RUN apk add --no-cache curl unzip bash && \
    cd /tmp && \
    curl -L "https://github.com/yahoo/kafka-manager/archive/${KM_VERSION}.tar.gz" -o kafka-manager.tar.gz && \
    tar xfvz kafka-manager.tar.gz && \
    cd "kafka-manager-${KM_VERSION}" && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -rf /tmp/* /root/.sbt /root/.ivy2

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/
ADD logback.xml /kafka-manager-${KM_VERSION}/conf/

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000

ENTRYPOINT [ "./start-kafka-manager.sh" ]