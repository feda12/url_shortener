FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /url_shortener
WORKDIR /url_shortener
COPY Gemfile /url_shortener/Gemfile
COPY Gemfile.lock /url_shortener/Gemfile.lock
RUN bundle install
COPY . /url_shortener

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
