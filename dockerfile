FROM ruby:2.3-slim

# Install dependencies
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential libpq-dev

# Set path
ENV INSTALL_PATH /faqbot


# Make directory
RUN mkdir -p $INSTALL_PATH

# Set path as main directory
WORKDIR $INSTALL_PATH

# Copy Gemfile into container
COPY Gemfile ./

# Install gems
RUN bundle install

# Copy project code into container
COPY . .

# Run server
CMD rackup config.ru -o 0.0.0.0