FROM python:3.11.0-slim-bullseye

# Create a non-root user.
RUN useradd -m -d /app robot

# Copy files to non-root user home directory
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY src/ requirements.txt docker-entrypoint.sh ./

# Install dependencies
RUN pip install -U pip && pip install -r requirements.txt \
&& chown -R robot: $APP_HOME \
&& chmod +x docker-entrypoint.sh

# Switch to non-root user
USER robot

RUN export PYTHONPATH=$APP_HOME

# 8000/tcp is the default interface that the application listens on.
EXPOSE 8000

# Start application
ENTRYPOINT ["./docker-entrypoint.sh"]