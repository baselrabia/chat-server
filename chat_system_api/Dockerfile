# syntax=docker/dockerfile:1

FROM ruby:3.2.4

# Set working directory
WORKDIR /app

# Install required packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev git libpq-dev nodejs libvips pkg-config cron && \
    rm -rf /var/lib/apt/lists/*

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

# Copy cron job script
COPY cron_job.sh /usr/bin/cron_job.sh
RUN chmod +x /usr/bin/cron_job.sh


# Ensure the working directory has correct permissions
RUN chown -R root:root /app

# Set environment variables
ENV RAILS_ENV=development

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the server in development mode
ENTRYPOINT ["entrypoint.sh"]
# Start cron and Rails server
CMD ["sh", "-c", "/usr/bin/cron_job.sh && bundle exec rails server -b 0.0.0.0"]
