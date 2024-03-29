FROM jenkins/jenkins:lts

MAINTAINER  devops <devops@aem.design>

LABEL   os="centos" \
        docker.source="https://hub.docker.com/_/jenkins/" \
        docker.dockerfile="https://github.com/jenkinsci/docker/blob/master/Dockerfile" \
        container.description="extended Jenkins image to allow configuration during image build" \
        version="1.0.0" \
        imagename="jenkins" \
        test.command=" java -version 2>&1 | grep 'java version' | sed -e 's/.*java version "\(.*\)".*/\1/'" \
        test.command.verify="1.8"

ARG VAULT_VERSION="3.2.0"

ENV JENKINS_SLAVE_COUNT=2 \
    JENKINS_HOME="/var/jenkins_home" \
    JENKINS_SLAVE_AGENT_PORT=50000 \
    JENKINS_UID=10001 \
    JENKINS_USER="jenkins" \
    JENKINS_GUID=10001 \
    JENKINS_GROUP="jenkins"


# this should be used with DOCKER RUN when running as slave
# docker run -d -p 8122:22 devops/jenkins /usr/sbin/sshd -D

USER root

COPY plugins_extra.txt /usr/share/jenkins/ref/plugins_extra.txt
ENV JENKINS_HOME /var/jenkins_home
ENV CASC_JENKINS_CONFIG /var/jenkins_conf

ARG JAVA_OPTS
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins_extra.txt

