
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

FROM ubuntu:bionic

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
    bats \
    build-essential \
    bzip2 \
    clang \
    cmake \
    curl \
    doxygen \
    findbugs \
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
    libzstd1-dev \
    locales \
    make \
    maven \
    openjdk-8-jdk \
    pinentry-curses \
    pkg-config \
    python \
    python2.7 \
    python-pip \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    python-pkg-resources \
    python-setuptools \
    python-wheel \
    #r-base \
    #r-base-dev \
    rsync \
    shellcheck \
    software-properties-common \
    sudo \
    valgrind \
    wget \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG R_VERSION=4.2.3
ARG OS_IDENTIFIER=ubuntu-1804

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
ENV MAVEN_HOME /usr
# JAVA_HOME must be set in Maven >= 3.5.0 (MNG-6003)
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV FINDBUGS_HOME /usr

#######
# Install Boost 1.72 (1.65 ships with Bionic)
#######
# hadolint ignore=DL3003
RUN mkdir -p /opt/boost-library \
    && curl -L https://sourceforge.net/projects/boost/files/boost/1.72.0/boost_1_72_0.tar.bz2/download > boost_1_72_0.tar.bz2 \
    && mv boost_1_72_0.tar.bz2 /opt/boost-library \
    && cd /opt/boost-library \
    && tar --bzip2 -xf boost_1_72_0.tar.bz2 \
    && cd /opt/boost-library/boost_1_72_0 \
    && ./bootstrap.sh --prefix=/usr/ \
    && ./b2 --without-python install \
    && cd /root \
    && rm -rf /opt/boost-library

######
# Install Google Protobuf 2.5.0 (2.6.0 ships with Xenial)
######
RUN mkdir -p /opt/protobuf-src && \
    curl -L -s -S \
    https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz \
    -o /opt/protobuf.tar.gz && \
    tar xzf /opt/protobuf.tar.gz --strip-components 1 -C /opt/protobuf-src
RUN cd /opt/protobuf-src && ./configure --prefix=/opt/protobuf && make install
ENV PROTOBUF_HOME /opt/protobuf
ENV PATH "${PATH}:/opt/protobuf/bin"

####
# Install pylint at fixed version (2.0.0 removed python2 support)
# https://github.com/PyCQA/pylint/issues/2294
####

RUN pip2 install \
    setuptools-scm==5.0.0 \
    lazy-object-proxy==1.6.0 \
    configparser==4.0.2 \
    pylint==1.9.2

####
# Install dateutil.parser
####
RUN pip2 install python-dateutil==2.7.3


####
# Upgrade pip3
####
RUN python3 -m pip install --upgrade pip

####
# Install pandas and pyarrow for Spark 3
# venv-pack for jupyterhub venv
####
RUN python3 -m pip install numpy==1.19.5 \
    pandas==1.0.5 \
    pyarrow==4.0.1 \
    venv-pack==0.2.0

###
# Set nvm environment variables to tune installation
###
# node.js 10.x by default
ENV NODE_VERSION 10.24.1
ENV NVM_DIR /usr/local/nvm
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

###
# Install nvm to manage multiple version of node.js (install node.js 10.x by default)
###
run mkdir -p $NVM_DIR \
    && curl -L -s -S https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

###
# Install node.js 10.x for web UI framework (4.2.6 ships with Xenial)
###
# hadolint ignore=DL3008
RUN source $NVM_DIR/nvm.sh \
    && nvm alias default lts/dubnium \
    && nvm use default \
    && npm install -g bower@1.8.8

###
# Install node.js 16.x for jupyterhub extensions
###
RUN source $NVM_DIR/nvm.sh \
    && nvm install 16.18.1

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
    && make \
    && make install \
    && cd /root \
    && rm -rf /opt/isa-l-src

###
# Avoid out of memory errors in builds
###
ENV MAVEN_OPTS -Xms256m -Xmx1536m

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

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
