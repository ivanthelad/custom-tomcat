FROM docker.io/tomcat:8-jre8
ENV WILDFLY_VERSION 10.0.0.Final
ENV MAVEN_VERSION 3.3.3i

LABEL io.k8s.description="Platform for building and running webapp applications on basic tomcat8" \
      io.k8s.display-name="Tomcat8" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,tomcat8,tomcat" \
      io.openshift.s2i.destination="/opt/s2i/destination"
