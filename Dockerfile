FROM ubuntu:17.04

RUN apt-get update -y
RUN apt-get install software-properties-common wget default-jre -y
# Rabix Install
RUN mkdir /usr/local/rabix
RUN wget https://github.com/rabix/bunny/releases/download/v1.0.3/rabix-1.0.3.tar.gz -O /tmp/rabix-1.0.3.tar.gz && \
	tar -xvf /tmp/rabix-1.0.3.tar.gz -C /usr/local/rabix --strip-components=1
ENV PATH=$PATH:/usr/local/rabix

RUN apt-get install gcc -y
RUN apt-get install zlib1g-dev libbz2-dev liblzma-dev make -y
RUN wget https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2 -O /tmp/samtools.tar.bz2 && \
    mkdir /tmp/samtools/ && \
    tar -xvf /tmp/samtools.tar.bz2 -C /tmp/samtools --strip-components=1 && \
    cd /tmp/samtools && \
    ./configure --prefix=/usr/local/samtools --without-curses && \
    make && \
    make install

RUN wget https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2 -O /tmp/bwa.tar.bz2 && \
    mkdir /usr/local/bwa && \
    tar -xvf /tmp/bwa.tar.bz2 -C /usr/local/bwa --strip-components=1 && \
    cd /usr/local/bwa && \
    make all

ENV PATH=/usr/local/samtools/bin:/usr/local/bwa:$PATH

RUN apt-get install vim less zip -y

RUN mkdir /usr/local/coinami/
COPY . /usr/local/coinami/
WORKDIR /usr/local/coinami/

VOLUME /reference
VOLUME /input
VOLUME /output

ENTRYPOINT ["rabix", "coinami.cwl", "/input/coinami.json", "--basedir", "/output"]
