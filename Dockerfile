FROM ruby:2.4-alpine
MAINTAINER WPScan Team <team@wpscan.org>

ARG BUNDLER_ARGS="--jobs=8 --without test development"

RUN adduser -h /wpscan -g WPScan -D wpscan
RUN echo "gem: --no-ri --no-rdoc" > /etc/gemrc

COPY . /wpscan
RUN chown -R wpscan:wpscan /wpscan

# runtime dependencies
RUN apk add --no-cache libcurl procps sqlite-libs && \
  # build dependencies
  apk add --no-cache --virtual build-deps git libcurl ruby-dev libffi-dev make gcc musl-dev zlib-dev procps sqlite-dev && \
  bundle install --system --gemfile=/wpscan/Gemfile $BUNDLER_ARGS && \
  apk del --no-cache build-deps

WORKDIR /wpscan
RUN rake install --trace

USER wpscan
RUN /usr/local/bundle/bin/wpscan --update --verbose

ENTRYPOINT ["/usr/local/bundle/bin/wpscan"]
CMD ["--help"]

