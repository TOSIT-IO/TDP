DOCKER_DIR=./build-env

docker build -t tdp-builder "$DOCKER_DIR" --build-arg DOCKER_GID_BUILD=$(getent group docker | cut -d: -f3)

USER_NAME=${SUDO_USER:=$USER}
USER_ID=$(id -u "${USER_NAME}")
GROUP_ID=$(id -g "${USER_NAME}")
TDP_HOME="${TDP_HOME:=$(pwd)}"

docker run --rm=true -t -i \
  -v "${TDP_HOME}:/tdp" \
  -w "/tdp" \
  -v "${HOME}/.m2:/home/builder/.m2${V_OPTS:-}" \
  -v "/var/run/docker.sock:/var/run/docker.sock" \
  -e "BUILDER_UID=${USER_ID}" \
  -e "BUILDER_GID=${GROUP_ID}" \
  -e "BUILDER_GROUPS=docker" \
  --ulimit nofile=500000:500000 \
  tdp-builder
