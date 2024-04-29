#!/bin/sh

VERSION_SCRIPT=0.1.0
DEBUG=false
PWD=$(pwd)
DIRECTORY=$PWD/docker/graalvm
IMAGE_NAME=my_graalvm
GRAALVM_VERSION=17
DOCKERFILE=Dockerfile
DEBUG_DOCKER_BUILD=""

usage() {
  echo "Usage: $0 [-v] [-V] [-h] [-D]"
  echo "Options:"
  echo "  -v          Version."
  echo "  -V          GraalVM Version."
  echo "  -D          Debug mode."
  echo "  -h          Display the help message"
}

valid_directory() {
    if [ ! -d "$DIRECTORY" ]; then
        echo "Directory $DIRECTORY does not exist."
        exit 1
    fi
}

while getopts ":vV:Dh" option; do
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

docker build $DEBUG_DOCKER_BUILD -t $IMAGE_NAME:$GRAALVM_VERSION -f $DIRECTORY/$DOCKERFILE .