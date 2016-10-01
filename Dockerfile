FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /blazer-app
WORKDIR /blazer-app
ADD ./rails_app /blazer-app
RUN bundle install

CMD ["/bin/sh", "-c", "rails g blazer:install && rake db:migrate"]
CMD ["/bin/sh", "-c", "bundle exec rails s -p 3000 -b '0.0.0.0'"]
