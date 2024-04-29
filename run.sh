#!/bin/sh

VERSION_SCRIPT=0.1.0
DEBUG=false
IMAGE_NAME=my_graalvm
GRAALVM_VERSION=17
SHELL=bash

usage() {
  echo "Usage: $0 [-v] [-V] [-b] [-h]"
  echo "Options:"
  echo "  -v          Version."
  echo "  -S          Shell."
  echo "  -V          GraalVM Version."
  echo "  -h          Display the help message"
}

while getopts ":vV:S:h" option; do
    case "${option}" in
        v)  # Version option
            echo $VERSION_SCRIPT
            ;;
        V)  # GraalVM version option
            GRAALVM_VERSION=${OPTARG}
            ;;
        S)  # GraalVM version option
            SHELL=${OPTARG}
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

docker run -it -t $IMAGE_NAME:$GRAALVM_VERSION $SHELL