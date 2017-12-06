FROM halilozercan/coinami:latest

RUN apt-get update -y
RUN apt-get install wget default-jre -y
RUN mkdir /usr/local/rabix
RUN wget https://github.com/rabix/bunny/releases/download/v1.0.3/rabix-1.0.3.tar.gz -O /tmp/rabix-1.0.3.tar.gz && \
	tar -xvf /tmp/rabix-1.0.3.tar.gz -C /usr/local/rabix --strip-components=1
ENV PATH=$PATH:/usr/local/rabix
COPY . /usr/local/coinami/

VOLUME /input
VOLUME /output