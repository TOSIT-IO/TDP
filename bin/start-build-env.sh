DOCKER_DIR=./build-env

docker build -t tdp-builder "$DOCKER_DIR"

USER_NAME=${SUDO_USER:=$USER}
USER_ID=$(id -u "${USER_NAME}")
GROUP_ID=$(id -g "${USER_NAME}")
TDP_HOME="${TDP_HOME:=$(pwd)}"

docker run --rm=true -t -i \
  -v "${TDP_HOME}:/tdp" \
  -w "/tdp" \
  -v "${HOME}/.m2:/home/builder/.m2${V_OPTS:-}" \
  -e "BUILDER_UID=${USER_ID}" \
  -e "BUILDER_GID=${GROUP_ID}" \
  --ulimit nofile=500000:500000 \
  tdp-builder
