FROM ruby:3.1.0

ENV RAILS_ENV=production

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
    imagemagick                                                                                                                         \
  && apt-get clean

WORKDIR /cafeapp

COPY Gemfile /cafeapp/Gemfile
COPY Gemfile.lock /cafeapp/Gemfile.lock
COPY package.json /cafeapp
COPY yarn.lock /cafeapp
COPY package.json /cafeapp

RUN bundle install --jobs=4
RUN yarn install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids
COPY . /cafeapp

ENV NODE_ENV=production
RUN ./bin/webpack

VOLUME /cafeapp/public
VOLUME /cafeapp/tmp

CMD bash -c "bundle exec puma -C config/puma.rb"
