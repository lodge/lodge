FROM solr:6.6.1
USER solr
ENV SOLR_HOME /opt/solr/server/solr
ARG ENV

RUN mkdir -p ${SOLR_HOME}/${ENV}
COPY config/base ${SOLR_HOME}/${ENV}
COPY config/core.${ENV}.properties ${SOLR_HOME}/${ENV}/core.properties
COPY config/sunspot ${SOLR_HOME}/configsets/sunspot

USER root
RUN chown -R solr:solr ${SOLR_HOME}/${ENV}
USER solr
