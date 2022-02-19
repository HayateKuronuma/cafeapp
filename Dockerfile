FROM ruby:3.1.0

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -                                                                             \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -                                                                  \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list                                      \
  && apt-get update                                                                                                                     \
  && apt-get remove -y                                                                                                                  \
    libmariadbclient18                                                                                                                  \
    libmariadbclient-dev-compat                                                                                                         \
    libmariadbclient-dev                                                                                                                \
  && apt-get install -y --allow-unauthenticated                                                                                         \
    default-mysql-client                                                                                                                \
    mariadb-client                                                                                                                      \
    nodejs                                                                                                                              \
    yarn                                                                                                                                \
    vim                                                                                                                                 \
  && apt-get clean

RUN mkdir /cafeapp
WORKDIR /cafeapp
ADD Gemfile /cafeapp/Gemfile
ADD Gemfile.lock /cafeapp/Gemfile.lock
RUN bundle install
ADD . /cafeapp
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
RUN mkdir -p tmp/sockets
