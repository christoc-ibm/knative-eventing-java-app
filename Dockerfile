FROM ibmjava:8-sdk AS builder
LABEL maintainer="IBM Java Engineering at IBM Cloud"

WORKDIR /app
COPY . /app

RUN apt-get update \
  && apt-get install -y --no-install-recommends maven=3.6.0-1~18.04.1
RUN mvn -N io.takari:maven:wrapper -Dmaven=3.5.0
RUN ./mvnw install

FROM ibmjava:8-sfj
LABEL maintainer="IBM Java Engineering at IBM Cloud"

COPY --from=builder /app/target/knative-eventing-1.0-SNAPSHOT.jar /app.jar

ENV JAVA_OPTS=""
ENV PORT=8080

EXPOSE 8080

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]
