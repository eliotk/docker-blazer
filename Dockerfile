FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

COPY ./rails_app/Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install

RUN mkdir /blazer-app
WORKDIR /blazer-app
ADD ./rails_app /blazer-app

CMD ["/bin/sh", "-c", "rails g blazer:install"]
CMD ["/bin/sh", "-c", "rake db:migrate"]
CMD ["/bin/sh", "-c", "bundle exec rails s -p 3000 -b '0.0.0.0'"]
