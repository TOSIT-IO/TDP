
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Dockerfile for installing the necessary dependencies for building Hadoop.
# See BUILDING.txt.

FROM ubuntu:focal
ARG OS_IDENTIFIER=ubuntu-2004

WORKDIR /root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#####
# Disable suggests/recommends
#####
RUN echo APT::Install-Recommends "0"\; > /etc/apt/apt.conf.d/10disableextras
RUN echo APT::Install-Suggests "0"\; >>  /etc/apt/apt.conf.d/10disableextras

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_TERSE true

# hadolint ignore=DL3008
RUN apt-get -q update \
    && apt-get -q install -y --no-install-recommends \
    ant \
    apt-utils \
    autoconf \
    automake \
    bats \
    build-essential \
    bzip2 \
    clang \
    cmake \
    curl \
    doxygen \
    fuse \
    g++ \
    gcc \
    git \
    gnupg-agent \
    gosu \
    libbcprov-java \
    libbz2-dev \
    libcurl4-openssl-dev \
    libfuse-dev \
    libkrb5-dev \
    libprotobuf-dev \
    libprotoc-dev \
    libsasl2-dev \
    libsnappy-dev \
    libssl-dev \
    libtool \
    libzstd-dev \
    locales \
    make \
    openjdk-8-jdk \
    pinentry-curses \
    pkg-config \
    python3 \
    python3-pip \
    python3-pkg-resources \
    python3-setuptools \
    python3-venv \
    python3-wheel \
    rsync \
    shellcheck \
    software-properties-common \
    sudo \
    unzip \
    valgrind \
    vim \
    wget \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV PYTHONIOENCODING=utf-8

# Install Maven 3.9.9
RUN mkdir /opt/maven \
    && curl -L https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip -o apache-maven-3.9.9-bin.zip \
    && unzip apache-maven-3.9.9-bin.zip \
    && mv apache-maven-3.9.9 /opt/maven \
    && rm apache-maven-3.9.9-bin.zip

ENV MAVEN_HOME=/opt/maven/apache-maven-3.9.9
ENV PATH=$PATH:$MAVEN_HOME/bin

######
# R version available in apt repos is not compatible when building spark R
# Install custom R version
######
ARG R_VERSION=4.2.3

RUN wget https://cdn.posit.co/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_amd64.deb && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm r-${R_VERSION}_1_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

######
# Set env vars required to build Hadoop
######
# JAVA_HOME must be set in Maven >= 3.5.0 (MNG-6003)
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64


#######
# Install Boost 1.86
#######

# hadolint ignore=DL3003
RUN  mkdir -p /opt/boost-library \
    && curl -L https://sourceforge.net/projects/boost/files/boost/1.86.0/boost_1_86_0.tar.bz2/download >boost_1_86_0.tar.bz2 \
    && mv boost_1_86_0.tar.bz2 /opt/boost-library \
    && cd /opt/boost-library \
    && tar --bzip2 -xf boost_1_86_0.tar.bz2 \
    && cd /opt/boost-library/boost_1_86_0 \
    && ./bootstrap.sh --prefix=/usr/ \
    && ./b2 --without-python install \
    && cd /root \
    && rm -rf /opt/boost-library

#######
# Install SpotBugs 4.2.2
#######
RUN mkdir -p /opt/spotbugs \
    && curl -L -s -S https://github.com/spotbugs/spotbugs/releases/download/4.2.2/spotbugs-4.2.2.tgz \
    -o /opt/spotbugs.tgz \
    && tar xzf /opt/spotbugs.tgz --strip-components 1 -C /opt/spotbugs \
    && chmod +x /opt/spotbugs/bin/*
ENV SPOTBUGS_HOME /opt/spotbugs

######
# Install Google Protobuf 3.21.12
######
# hadolint ignore=DL3003
RUN mkdir -p /opt/protobuf-src \
    && curl -L -s -S \
    https://github.com/protocolbuffers/protobuf/archive/refs/tags/v3.21.12.tar.gz \
    -o /opt/protobuf.tar.gz \
    && tar xzf /opt/protobuf.tar.gz --strip-components 1 -C /opt/protobuf-src \
    && cd /opt/protobuf-src/ \
    && ./autogen.sh \
    && ./configure --prefix=/opt/protobuf \
    && make "-j$(nproc)" \
    && make install \
    && cd /root \
    && rm -rf /opt/protobuf-src
ENV PROTOBUF_HOME /opt/protobuf
ENV PATH "${PATH}:/opt/protobuf/bin"


# Use venv because of new python system protection
ENV VENV_PATH=/opt/venv
RUN python3 -m venv $VENV_PATH
ENV PATH "$VENV_PATH/bin:$PATH"

####
# Upgrade pip3
####
RUN python3 -m pip install --upgrade pip setuptools wheel

####
# Install pandas and pyarrow for Spark 3
# venv-pack for jupyterhub venv
####
RUN $VENV_PATH/bin/pip3 install numpy==1.24.4 \
    pandas==2.0.3 \
    pyarrow==14.0.2 \
    venv-pack==0.2.0

# Install pylint and python-dateutil
RUN $VENV_PATH/bin/pip3 install pylint==2.6.0 python-dateutil==2.8.2

###
## Install Yarn 1.12.1 for web UI framework
####
RUN curl -s -S https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list \
    && apt-get -q update \
    && apt-get install -y --no-install-recommends yarn=1.21.1-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

###
# Install hadolint
####
RUN curl -L -s -S \
    https://github.com/hadolint/hadolint/releases/download/v1.11.1/hadolint-Linux-x86_64 \
    -o /bin/hadolint \
    && chmod a+rx /bin/hadolint \
    && shasum -a 512 /bin/hadolint | \
    awk '$1!="734e37c1f6619cbbd86b9b249e69c9af8ee1ea87a2b1ff71dccda412e9dac35e63425225a95d71572091a3f0a11e9a04c2fc25d9e91b840530c26af32b9891ca" {exit(1)}'

######
# Intel ISA-L 2.29.0
######
# hadolint ignore=DL3003,DL3008
RUN mkdir -p /opt/isa-l-src \
    && apt-get -q update \
    && apt-get install -y --no-install-recommends automake yasm \
    && apt-get clean \
    && curl -L -s -S \
    https://github.com/intel/isa-l/archive/v2.29.0.tar.gz \
    -o /opt/isa-l.tar.gz \
    && tar xzf /opt/isa-l.tar.gz --strip-components 1 -C /opt/isa-l-src \
    && cd /opt/isa-l-src \
    && ./autogen.sh \
    && ./configure \
    && make "-j$(nproc)" \
    && make install \
    && cd /root \
    && rm -rf /opt/isa-l-src

###
# Avoid out of memory errors in builds
###
ENV MAVEN_OPTS -Xms256m -Xmx3072m

# Skip gpg verification when downloading Yetus via yetus-wrapper
ENV HADOOP_SKIP_YETUS_VERIFICATION true

###
# Everything past this point is either not needed for testing or breaks Yetus.
# So tell Yetus not to read the rest of the file:
# YETUS CUT HERE
###

# Hugo static website generator for new hadoop site
RUN curl -L -o hugo.deb https://github.com/gohugoio/hugo/releases/download/v0.58.3/hugo_0.58.3_Linux-64bit.deb \
    && dpkg --install hugo.deb \
    && rm hugo.deb

# Install gradle 8.1.1
RUN  mkdir -p /opt/gradle \
    && curl -L https://services.gradle.org/distributions/gradle-8.1.1-bin.zip -o gradle-8.1.1-bin.zip \
    && unzip gradle-8.1.1-bin.zip \
    && mv gradle-8.1.1 /opt/gradle \
    && rm gradle-8.1.1-bin.zip

ENV GRADLE_HOME=/opt/gradle/gradle-8.1.1
ENV PATH=$PATH:$GRADLE_HOME/bin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
