FROM python:3.12-slim

RUN apt-get update && rm -rf /var/lib/apt/lists/*

RUN pip install "beancount==3.1.0" "fava==1.30.2"

WORKDIR /app/data

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD sh -c "fava /app/data/main.bean --host 0.0.0.0 --port 5001"

