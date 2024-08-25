# Use the official Ruby image
FROM ruby:3.1

# Set environment variables
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs yarn libmysqlclient-dev

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install the Ruby dependencies
RUN bundle install

# Copy the entire application into the container
COPY . .

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose the port the app runs on
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
