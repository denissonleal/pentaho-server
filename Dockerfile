FROM openjdk:8-jre-alpine
MAINTAINER Denisson Leal, Genival Rocha

ENV PENTAHO_HOME /opt/pentaho
ENV PENTAHO_JAVA_HOME $JAVA_HOME
ENV CATALINA_OPTS="-Djava.awt.headless=true -Xms4096m -Xmx6144m -XX:MaxPermSize=256m -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000"

RUN apk add --update wget unzip bash postgresql-client ttf-dejavu

# Setup pentaho user
RUN mkdir -p ${PENTAHO_HOME}/server; mkdir ${PENTAHO_HOME}/.pentaho; adduser -D -s /bin/sh -h ${PENTAHO_HOME} pentaho; chown -R pentaho:pentaho ${PENTAHO_HOME}
USER pentaho
WORKDIR ${PENTAHO_HOME}/server

RUN wget https://sourceforge.net/projects/pentaho/files/Business%20Intelligence%20Server/7.1/pentaho-server-ce-7.1.0.0-12.zip/download -O tmp.zip && \
  unzip -q tmp.zip -d ${PENTAHO_HOME}/server && \
  rm -f tmp.zip

RUN ls $PENTAHO_HOME/server/pentaho-server

RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.48.zip -O tmp-mysql.zip && \
	unzip -q tmp-mysql.zip -d tmp-mysql && \
	mv tmp-mysql/mysql-connector-java-5.1.48/mysql-connector-java-5.1.48.jar ${PENTAHO_HOME}/server/pentaho-server/tomcat/lib/ && \
	rm -r tmp-mysql.zip tmp-mysql

ENV PENTAHO_SERVER $PENTAHO_HOME/server/pentaho-server

RUN wget http://downloads.meteorite.bi/saiku3/saiku-plugin-p7.1-3.90.zip -O tmp-saiku.zip && \
	unzip -q tmp-saiku.zip -d tmp-saiku && \
	mv tmp-saiku/saiku $PENTAHO_SERVER/pentaho-solutions/system/ && \
	rm -r tmp-saiku.zip tmp-saiku

COPY license/license.lic $PENTAHO_SERVER/pentaho-solutions/system/saiku/

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "$PENTAHO_SERVER/start-pentaho.sh && sleep 60 && tail -f $PENTAHO_SERVER/tomcat/logs/*.log"]
