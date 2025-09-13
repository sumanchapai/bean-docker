FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install "beancount==3.1.0" "fava==1.30.2"

WORKDIR /app/data

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD sh -c "fava /app/data/main.beancount --host 0.0.0.0 --port ${PORT:-5000}"

