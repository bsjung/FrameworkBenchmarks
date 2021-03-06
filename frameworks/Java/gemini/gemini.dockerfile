FROM maven:3.6.1-jdk-11-slim as maven

WORKDIR /gemini

COPY src src
COPY pom.xml pom.xml

RUN mvn -q compile
RUN mv src/main/webapp/WEB-INF/configuration/gemini.conf src/main/webapp/WEB-INF/configuration/Base.conf
RUN mvn -q war:war

FROM openjdk:11.0.3-jdk-stretch

WORKDIR /resin
RUN curl -sL http://caucho.com/download/resin-4.0.61.tar.gz | tar xz --strip-components=1
RUN rm -rf webapps/*
COPY --from=maven /gemini/target/HelloWorld-0.0.1.war webapps/ROOT.war
COPY resin.xml conf/resin.xml
CMD ["java", "-jar", "lib/resin.jar", "console"]
