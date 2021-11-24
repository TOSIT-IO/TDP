# Build Environment

Building Hadoop and other big data ecosystem project can be quite complex. Having an “official” building container is a good addition to any open source project, it helps both new developers on their journey to a first contribution as well as maintainers to reproduce issues more easily by providing a controlled and reproducible environment.

The Docker image in `Dockerfile` is based on the one provided in the official [image](https://raw.githubusercontent.com/apache/hadoop/trunk/dev-support/docker/Dockerfile) provided by Apache. This image has got all the pre-requisites to build:

- [Apache Hadoop (HDFS and YARN)](https://hadoop.apache.org/)
- [Apache Spark](https://spark.apache.org/)
- [Apache Hive](https://hive.apache.org/)
- [Apache Tez](https://tez.apache.org/)
- [Apache Zeppelin](https://zeppelin.apache.org/)

## Build the image

The image can be built and tagged with:

```
docker build . -t tdp-builder
```

This is a base image on which you need to build another image containing you local user. This is mandatory because files needs to be written to your local Maven cache with the right permissions.

```
docker build -t "hadoop-build-${USER_ID}" - <<UserSpecificDocker
FROM tdp-builder
RUN groupadd --non-unique -g ${GROUP_ID} ${USER_NAME}
RUN useradd -g ${GROUP_ID} -u ${USER_ID} -k /root -m ${USER_NAME}
RUN echo "${USER_NAME} ALL=NOPASSWD: ALL" > "/etc/sudoers.d/hadoop-build-${USER_ID}"
ENV HOME /home/${USER_NAME}

UserSpecificDocker
```

All these steps can run with `./bin/start-build-env.sh`

## Start the container

The container should be started with:

```
docker run --rm=true -t -i \
  -v "$(pwd):/tdp" \
  -w "/tdp" \
  -v "${HOME}/.m2:/home/${USER_NAME}/.m2${V_OPTS:-}" \
  -u "${USER_NAME}" \
  --ulimit nofile=500000:500000 \
  "tdp-builder-${USER_NAME}"
```

The important parameters are:
- ~/.m2 should mounted to have the compiled jar outside the container and use of your local maven cache for faster builds
- --ulimit nofile=500000:500000 is helpful to run the tests (some are resource intensive and break easily with a low ulimit)
