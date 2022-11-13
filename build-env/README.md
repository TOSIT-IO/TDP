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

```bash
docker build . -t tdp-builder
```

This image contains an entrypoint that create a `builder` user on the fly if you specify `BUILDER_UID` and `BUILDER_GID` as environment variables. This allow to have a `builder` user with the same `uid` and `gid` as the host user. If these variables are not defined, the `builder` user will not be created.

The container needs to start as root to create the `builder` user so do not run tdp-builder with `docker run --user ...`, instead use variables above. The entrypoint will use `gosu` to exec command as `builder` user.

## Start the container

The container should be started with:

```bash
docker run --rm=true -t -i \
  -v "${TDP_HOME:-${PWD}}:/tdp" \
  -w "/tdp" \
  -v "${HOME}/.m2:/home/builder/.m2${V_OPTS:-}" \
  -e "BUILDER_UID=$(id -u)" \
  -e "BUILDER_GID=$(id -g)" \
  --ulimit nofile=500000:500000 \
  tdp-builder
```

The important parameters are:
- ~/.m2 should mounted to have the compiled jar outside the container and use of your local maven cache for faster builds
- `BUILDER_UID` and `BUILDER_GID` should be defined to create the `builder` user to not build as root
- --ulimit nofile=500000:500000 is helpful to run the tests (some are resource intensive and break easily with a low ulimit)
- TDP_HOME is where the TDP repositories (hadoop, hive, hbase, etc) are cloned

## Start script

All these steps can run with `./bin/start-build-env.sh`

**Note:** By default, the current directory is mounted to the build container, you can change the mounted directory to where the TDP source repository live by running `export TDP_HOME="/path/to/tdp"` before running the `start-build-env.sh` script.
