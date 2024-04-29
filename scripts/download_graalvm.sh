#!/bin/sh

VERSION_SCRIPT=0.1.0
DEBUG=false

# https://download.oracle.com/graalvm/17/latest/graalvm-jdk-17_linux-aarch64_bin.tar.gz

PATH_TMP=/tmp/graalvm
GRAALVM_VERSION=17
GRAALVM_ARCH=linux-aarch64
GRAALVM_URL=https://download.oracle.com/graalvm/${GRAALVM_VERSION}/latest/graalvm-jdk-${GRAALVM_VERSION}_${GRAALVM_ARCH}_bin.tar.gz
PATH_PWD=$(pwd)
FILE_JAVA_HOME=java.sh
PATH_PROFILE=/etc/profile.d/$FILE_JAVA_HOME

usage() {
  echo "Usage: $0 [-v] [-V] [-A] [-h]"
  echo "Options:"
  echo "  -v          Version."
  echo "  -V          GraalVM version."
  echo "  -A          GraalVM arch."
  echo "  -h          Display the help message"
}

show_info() {
    echo "Version: $GRAALVM_VERSION"
    echo "Arch: $GRAALVM_ARCH"
    echo "URL: $GRAALVM_URL"
}

while getopts ":vV:A:h" option; do
    case "${option}" in
        v)  # Version option
            echo $VERSION_SCRIPT
            ;;
        V)  # GraalVM version option
            GRAALVM_VERSION=${OPTARG}
            ;;
        A)  # GraalVM arch option
            GRAALVM_ARCH=${OPTARG}
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
GRAALVM_URL=https://download.oracle.com/graalvm/${GRAALVM_VERSION}/latest/graalvm-jdk-${GRAALVM_VERSION}_${GRAALVM_ARCH}_bin.tar.gz
show_info

# Create tmp directory
mkdir -p $PATH_TMP

# Download GraalVM
wget -O $PATH_TMP/graalvm-${GRAALVM_VERSION}.tar.gz $GRAALVM_URL

# Extract GraalVM  
tar -xzf $PATH_TMP/graalvm-${GRAALVM_VERSION}.tar.gz -C $PATH_TMP

# Find the folder name
FOLDER_GRAALVM=$(ls -1 $PATH_TMP | grep graalvm-jdk-${GRAALVM_VERSION})
#echo $FOLDER_GRAALVM

# Move GraalVM to /opt
mv $PATH_TMP/$FOLDER_GRAALVM /opt/graalvm-${GRAALVM_VERSION}

# Create a symbolic link
ln -s /opt/graalvm-${GRAALVM_VERSION} /opt/graalvm

# show the content of /opt
ls -l /opt

#declare -a binary_graalvm
binary_graalvm="java javac jar javadoc javap jdeps jdeprscan native-image native-image-inspect rebuild-images gu jshell polyglot"

# Add GraalVM to the alternatives
for binary in ${binary_graalvm};
do
    update-alternatives --install /usr/bin/$binary $binary /opt/graalvm/bin/$binary 1
done

# Add JAVA_HOME and PATH to the profile
if [ ! -e $PATH_PROFILE ]; then
    echo "export GRAALVM_HOME=/opt/graalvm" | tee -a $PATH_PROFILE
    echo "export PATH=\$GRAALVM_HOME/bin:\$PATH" | tee -a $PATH_PROFILE
    echo "export JAVA_HOME=\$GRAALVM_HOME" | tee -a $PATH_PROFILE

    #echo "source ${PATH_PROFILE}" | tee -a ~/.profile
    echo "source ${PATH_PROFILE}" | tee -a ~/.bashrc
fi




