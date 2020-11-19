FROM alpine:3.5

RUN apk add --no-cache curl

COPY ./setup.sh /setup.sh
COPY ./index_mapping.sh /index_mapping.sh
COPY ./index_mapping_telegraf.sh /index_mapping_telegraf.sh
COPY ./index_mapping_workflow.sh /index_mapping_workflow.sh

CMD ["/setup.sh"]
