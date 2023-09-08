# FROM ubuntu:bionic-20180426
FROM python:3.10 as builder

ENV VIRTUAL_ENV=/home/ubuntu/picard_metrics_sqlite/pms_env/

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m venv $VIRTUAL_ENV

COPY ./ /opt

WORKDIR /opt

RUN pip install greenlet==2.0.0

RUN pip install tox && tox -p

FROM python:3.10

COPY --from=builder /opt/dist/*.tar.gz /opt
COPY requirements.txt /opt

WORKDIR /opt

RUN pip install -r requirements.txt *.tar.gz \
	&& rm -f *.tar.gz requirements.txt

ENTRYPOINT ["picard_metrics_sqlite"]

CMD ["--help"]
