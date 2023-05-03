# Build stage
FROM python:3.11-alpine AS build

RUN apk add --no-cache build-base

WORKDIR /app

# setup dependencies and build a venv
COPY Pipfile .
COPY Pipfile.lock .
COPY app.py .

RUN python -m venv /opt/venv
ENV PATH /opt/venv/bin:$PATH

RUN pip install pipenv
RUN pipenv install --deploy --system --ignore-pipfile

# Production stage
FROM python:3.11-alpine AS production

# We're going to run the app as a non-root user
ARG USERNAME=nonroot
ARG UID=1000
ARG GROUPNAME=$USERNAME
ARG GID=$UID
ARG USERHOME=/home/$USERNAME

RUN addgroup -g $GID $GROUPNAME
RUN adduser -u $UID -G $GROUPNAME -s /bin/sh -h $USERHOME -D $USERNAME

COPY --from=build /opt/venv /opt/venv
COPY --from=build /app/app.py /app/

RUN chown -R $USERNAME:$GROUPNAME /app

# Setup our user's python env
USER $USERNAME
WORKDIR /app

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1
ENV PATH $USERHOME/.local/bin:/opt/venv/bin:$PATH

## Run the application
ENTRYPOINT ["pipenv", "run", "gunicorn", "--chdir", "/home/nonroot/", "app:app", "-w", "1", "--log-level", "ERROR", "--bind", "0.0.0.0:3000"]