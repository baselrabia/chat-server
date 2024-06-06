# syntax=docker/dockerfile:1

FROM ruby:3.2.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . /app

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Ensure the working directory has correct permissions
RUN chown -R root:root /app

# Set environment variables
ENV RAILS_ENV=development

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the server in development mode
ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
