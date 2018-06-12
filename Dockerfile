FROM debian:9.4

# need to be root to do the installation
USER root

# Install required tools
RUN apt-get -y update \
    && apt-get -y install wget curl unzip default-jdk gnupg
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Provide MTA toolset
ENV MTA_HOME=/opt/mta
RUN mkdir -p  ${MTA_HOME}
ADD tools/mta.jar ${MTA_HOME}/mta.jar

RUN echo "java -jar ${MTA_HOME}/mta.jar \$*" > ${MTA_HOME}/mta.sh
RUN chmod +x ${MTA_HOME}/mta.sh
ENV PATH=/opt/mta/:$PATH

# Install neo sdk
ENV NEO_HOME=/usr/local/tools/neo-java-web-sdk
RUN mkdir -p ${NEO_HOME} \
   && wget http://central.maven.org/maven2/com/sap/cloud/neo-java-web-sdk/3.53.13.3/neo-java-web-sdk-3.53.13.3.zip -O /tmp/neo-java-web-sdk.zip  \
   && unzip -d ${NEO_HOME} /tmp/neo-java-web-sdk.zip \
   && rm /tmp/neo-java-web-sdk.zip
ENV PATH=/usr/local/tools/neo-java-web-sdk/tools/:$PATH

# Install node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Upgrade npm
RUN npm install npm@5.7.1 -g

# Add SAP NPM registry
RUN npm config set @sap:registry https://npm.sap.com/
