FROM python:3.11-alpine
WORKDIR /app
COPY ./app.py ./requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 3000
CMD ["python", "app.py"]