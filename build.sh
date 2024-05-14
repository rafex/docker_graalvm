#!/bin/sh

VERSION_SCRIPT=0.1.0
DEBUG=false
PWD=$(pwd)
DIRECTORY=$PWD/docker/graalvm
IMAGE_NAME=my_graalvm
CUSTOM_IMAGE_NAME="-custom"
GRAALVM_VERSION=17
DOCKERFILE=Dockerfile
DEBUG_DOCKER_BUILD=""
DOCKERFILE_EXTENSION=""

usage() {
  echo "Usage: $0 [-v] [-V] [-h] [-D] [-f]"
  echo "Options:"
  echo "  -v          Version."
  echo "  -V          GraalVM Version."
  echo "  -f          Dockerfile."
  echo "  -D          Debug mode."
  echo "  -h          Display the help message"
}

valid_directory() {
    if [ ! -d "$DIRECTORY" ]; then
        echo "Directory $DIRECTORY does not exist."
        exit 1
    fi
}

get_extension() {
  local filename=$1
  local extension=$(echo "$filename" | sed 's/.*\.//')
  echo "$extension"
}

while getopts ":vV:f:Dh" option; do
    case "${option}" in
        v)  # Version option
            echo $VERSION_SCRIPT
            ;;
        V)  # GraalVM version option
            GRAALVM_VERSION=${OPTARG}
            DIRECTORY=$DIRECTORY/$GRAALVM_VERSION
            valid_directory
            ;;
        D)  # Debug option
            DEBUG=true
            ;;
        f)  # Debug option
            DOCKERFILE=${OPTARG}
            IMAGE_NAME=${IMAGE_NAME}${CUSTOM_IMAGE_NAME}
            DOCKERFILE_EXTENSION="-$(get_extension $DOCKERFILE)"
            ;;    
        h)  # Help option
            usage
            exit 0
            ;;
        \?) # Invalid option
            echo "Invalid option: -$OPTARG"
            usage
            exit 1
            ;;
    esac
done
shift $(($OPTIND - 1))
echo "Remaining arguments are: $*"

# valid debug
if [ "$DEBUG" = true ]; then
    echo "Version: $GRAALVM_VERSION"
    echo "Image Name: $IMAGE_NAME"
    echo "Directory: $DIRECTORY"
    DEBUG_DOCKER_BUILD="--progress=plain --no-cache"
fi

docker build $DEBUG_DOCKER_BUILD -t $IMAGE_NAME:$GRAALVM_VERSION$DOCKERFILE_EXTENSION -f $DIRECTORY/$DOCKERFILE .