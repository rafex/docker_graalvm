#!/bin/sh

VERSION_SCRIPT=0.1.0
DEBUG=false
PWD=$(pwd)
DIRECTORY=$PWD/docker/graalvm
GRAALVM_VERSION=17
DOCKERFILE=Dockerfile
DEBUG_DOCKER_BUILD=""

usage() {
  echo "Usage: $0 [-v] [-V] [-h]"
  echo "Options:"
  echo "  -v          Version."
  echo "  -V          GraalVM Version."
  echo "  -h          Display the help message"
}

valid_directory() {
    if [ ! -d "$DIRECTORY" ]; then
        echo "Directory $DIRECTORY does not exist."
        exit 1
    fi
}

while getopts ":vV:h" option; do
    case "${option}" in
        v)  # Version option
            echo $VERSION_SCRIPT
            ;;
        V)  # GraalVM version option
            GRAALVM_VERSION=${OPTARG}
            DIRECTORY=$DIRECTORY/$GRAALVM_VERSION
            valid_directory
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
    echo "Arch: $GRAALVM_ARCH"
    echo "Directory: $DIRECTORY"
    DEBUG_DOCKER_BUILD="--progress=plain --no-cache"
fi

docker build $DEBUG_DOCKER_BUILD -t my_graalvm:$GRAALVM_VERSION -f $DIRECTORY/$DOCKERFILE .