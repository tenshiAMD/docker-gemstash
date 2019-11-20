FROM ruby:2.6

ENV GEMSTASH_USER="gemstash"
ENV GEMSTASH_HOME="/home/${GEMSTASH_USER}"
RUN groupadd -g "9999" "${GEMSTASH_USER}" && \
    useradd -u "9999" -g "${GEMSTASH_USER}" "${GEMSTASH_USER}"

ENV RACK_ENV="production"

RUN mkdir -p "${GEMSTASH_HOME}/app"
WORKDIR "${GEMSTASH_HOME}/app"
COPY "app/" "${GEMSTASH_HOME}/app"
RUN bundle install --jobs 4 --retry 3

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir -p $GEMSTASH_HOME/.gemstash
RUN chown -R $GEMSTASH_USER:$GEMSTASH_USER $GEMSTASH_HOME

USER $GEMSTASH_USER

EXPOSE 9292

CMD ["bundle", "exec", "gemstash", "start", "--config-file=/home/gemstash/app/config.yml", "--no-daemonize"]
