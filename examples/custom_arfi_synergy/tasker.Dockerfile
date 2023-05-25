FROM ghcr.io/asreview/asreview:v1.2

RUN apt-get update && \
    apt-get install -y curl ca-certificates amqp-tools python \
       --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && pip install pika

#### Don't modify above this line
RUN pip install synergy-dataset
RUN mkdir -p /app/data
RUN synergy get -l -o ./app/data

COPY ./custom_arfi.txt.template /app/custom_arfi.txt.template
#### Don't modify below this line

COPY ./split-file.py /app/split-file.py
COPY ./tasker-send.py /app/tasker-send.py
COPY ./tasker.sh /app/tasker.sh

ENV PYTHONUNBUFFERED=1
WORKDIR /app/workdir

ENTRYPOINT [ "/bin/bash", "/app/tasker.sh" ]