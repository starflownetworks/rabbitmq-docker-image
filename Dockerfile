FROM rabbitmq:3.7-management-alpine

RUN rabbitmq-plugins --offline enable rabbitmq_mqtt

RUN apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	&& runDeps="$( \
		scanelf --needed --nobanner /tmp/envsubst \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
    && apk add --virtual .rundeps $runDeps \
	&& apk del .gettext \
	&& mv /tmp/envsubst /usr/local/bin/

EXPOSE 1883
