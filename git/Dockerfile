FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

RUN git init /data

WORKDIR /app

RUN pip install fastapi==0.116.1

RUN pip install Jinja2==3.1.6

RUN pip install python-multipart==0.0.20

RUN pip install beancount==3.1.0

RUN pip install uvicorn==0.35.0

CMD ["uvicorn", "main:app", "--port", "5002"]
