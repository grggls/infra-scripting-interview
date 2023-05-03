FROM python:3.11-alpine

# We're going to run the app as a non-root user
ARG USERNAME=nonroot
ARG UID=1000
ARG GROUPNAME=$USERNAME
ARG GID=$UID
ARG USERHOME=/home/$USERNAME

RUN addgroup -g $GID $GROUPNAME
RUN adduser -u $UID -G $GROUPNAME -h $USERHOME -D $USERNAME

# Setup python env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

# Setup our home directory and install our pipenv
USER $USERNAME
WORKDIR $USERHOME
COPY Pipfile .
COPY Pipfile.lock .
COPY app.py .

RUN pip install pipenv
ENV PATH="$USERHOME/.local/bin:$PATH"
RUN pipenv install --deploy

## Run the application
ENTRYPOINT ["pipenv", "run", "gunicorn", "--chdir", "/home/nonroot/", "app:app", "-w", "1", "--log-level", "ERROR", "--bind", "0.0.0.0:3000"]
