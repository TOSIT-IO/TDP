FROM quay.io/pypa/manylinux2014_x86_64:2024.09.05-1

# Group paquets and repos
RUN yum groups mark install "Development Tools"
RUN yum groups mark convert "Development Tools"
RUN yum group install -y "Development Tools"
RUN yum install -y epel-release

# Base packets + specific (Rust, Kerberos, DB, etc.)
RUN yum update -y && yum install -y \
    cmake \
    curl \
    cyrus-sasl-devel \
    cyrus-sasl-gssapi \
    gcc \
    git \
    gmp-devel \
    krb5-devel \
    libffi-devel \
    libtidy-devel \
    libxml2-devel \
    libxslt-devel \
    mariadb-devel \
    maven \
    openldap-devel \
    openssl-devel \
    postgresql-devel \
    rsync \
    rust \
    rust-toolset-7 \
    sqlite-devel \
    sudo \
    swig \
    wget \
    zlib-devel

# Diverse configurations
RUN ln -s /usr/local/bin/python3.6 /usr/local/bin/python3
RUN mkdir /usr/local/share/jupyter && chmod 777 /usr/local/share/jupyter
RUN mkdir /opt/_internal/cpython-3.6.15/etc && chmod 777 /opt/_internal/cpython-3.6.15/etc
RUN mkdir -p /hue/build

# Pip update
RUN /usr/local/bin/python3.6 -m pip install --upgrade pip
RUN /usr/local/bin/python3.6 -m pip install --upgrade wheel
RUN /usr/local/bin/python3.6 -m pip install --upgrade setuptools

# NVM & NodeJS
RUN mkdir /usr/local/nvm
WORKDIR /usr/local/nvm
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh --output install.sh && chmod u+x install.sh
RUN export NVM_DIR=/usr/local/nvm && ./install.sh
RUN source /usr/local/nvm/nvm.sh && source /usr/local/nvm/bash_completion && nvm install lts/gallium

# GoSu
ENV GOSU_VERSION=1.11
RUN gpg --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu \
    # Verify that the binary works
    && gosu nobody true

# Create the user builder
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
