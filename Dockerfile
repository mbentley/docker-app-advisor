# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:latest
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

# install dependencies
RUN apk --no-cache add curl gcompat openjdk21 tar zlib

# create non-root user (app-advisor)
RUN mkdir /opt/app-advisor &&\
  addgroup -g 2063 app-advisor &&\
  adduser -h /opt/app-advisor -D -u 2063 -g app-advisor -G app-advisor -s /sbin/nologin app-advisor &&\
  chown -R app-advisor:app-advisor /opt/app-advisor

# get app database info (https://docs.vmware.com/en/Tanzu-Spring-Runtime/Commercial/Tanzu-Spring-Runtime/app-advisor-install-app-advisor.html#download-and-update-the-support-and-vulnerabilities-datasets)
RUN mkdir -p /tmp/spring-support-database /tmp/cve-database/maven /opt/app-advisor &&\
  chown -R app-advisor:app-advisor /opt/app-advisor &&\
  curl -o /tmp/spring-support-database/init-spring-projects.json "https://storage.googleapis.com/shar-external-resources/spring-support-database/init-spring-projects.json" &&\
  curl -o /tmp/cve-database/maven/all-cves-by-path.ndjson "https://storage.googleapis.com/shar-external-resources/cve-database/all-cves-by-path.ndjson"

# build arg for your artifactory token
ARG ARTIFACTORY_TOKEN

# download the spring app advisor server
RUN curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" -o /opt/app-advisor/upgrade-service.jar -X GET "https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-server/0.0.4/application-advisor-server-0.0.4.jar" &&\
  chown -R app-advisor:app-advisor /opt/app-advisor

### the below commented out RUN commands would be if you want to also act as the "client"

## download the advisor CLI
#RUN curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" -o /tmp/advisor-linux.tar -X GET "https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/0.0.4/application-advisor-cli-linux-0.0.4.tar" &&\
#  cd /usr/local/bin &&\
#  tar -xf /tmp/advisor-linux.tar --strip-components=1 --exclude=./META-INF &&\
#  rm /tmp/advisor-linux.tar
#
## install maven
#RUN curl -L -o /tmp/apache-maven-3.9.7-bin.tar.gz "https://dlcdn.apache.org/maven/maven-3/3.9.7/binaries/apache-maven-3.9.7-bin.tar.gz" &&\
#  cd /opt &&\
#  tar xvf /tmp/apache-maven-3.9.7-bin.tar.gz &&\
#  rm /tmp/apache-maven-3.9.7-bin.tar.gz
#
## set PATH
## PATH="${PATH}:/opt/apache-maven-3.9.7/bin"

USER app-advisor:app-advisor
WORKDIR /opt/app-advisor

ENTRYPOINT ["java","-jar","upgrade-service.jar"]
