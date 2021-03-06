FROM docker.io/tomcat:8-jre8
ENV TOMCAT_VERSION 8
ENV MAVEN_VERSION 3.3.3

LABEL io.k8s.description="Platform for building and running webapp applications on basic tomcat8" \
      io.k8s.display-name="Tomcat8" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,tomcat8,tomcat" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.s2i.destination="/opt/s2i/destination"

ENV HOME=/home/jboss
ENV PATH=/home/jboss/src/bin:/jboss/home/bin:$PATH





LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i

# DEPRECATED: This label will be kept here for backward compatibility
LABEL io.s2i.scripts-url=image:///usr/local/s2i

# Deprecated. Use above LABEL instead, because this will be removed in future versions.
ENV STI_SCRIPTS_URL=image:///usr/local/s2i

# Path to be used in other layers to place s2i scripts into
ENV STI_SCRIPTS_PATH=/usr/local/s2i
RUN  mkdir -p /opt/s2i/destination
RUN mkdir -p /home/jboss/
RUN groupadd -r jboss -g 185 && useradd -u 185 -r -g jboss -m -d /home/jboss -s /sbin/nologin -c "JBoss user" jboss
RUN (curl -0 http://www.us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p /opt/s2i/destination



# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH
COPY ./s2i/jboss-settings.xml $HOME/.m2/settings.xml
RUN chown -R 1001:0 /usr/local/tomcat && \
    chmod -R ug+rw /usr/local/tomcat && \
    chmod -R 777 /usr/local/s2i  && \
    chmod -R 777 /home/jboss  && \
    chmod -R 777 /opt/s2i/destination

USER 185
WORKDIR ${HOME}
CMD $STI_SCRIPTS_PATH/usage

