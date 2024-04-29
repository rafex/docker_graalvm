#!/bin/sh

PATH_TMP=/tmp/graalvm
GRAALVM_VERSION=17
GRAALVM_ARCH=linux-x64
GRAALVM_URL=https://download.oracle.com/graalvm/${GRAALVM_VERSION}/latest/graalvm-jdk-${GRAALVM_VERSION}_${GRAALVM_ARCH}_bin.tar.gz
PATH_PWD=$(pwd)
FILE_JAVA_HOME=java.sh
PATH_PROFILE=/etc/profile.d/$FILE_JAVA_HOME

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

binary_graalvm=(
    "java"
    "javac"
    "jar"
    "javadoc"
    "javap"
    "jdeps"
    "jdeprscan"
    "native-image"
    "native-image-inspect"
    "rebuild-images"
    "gu"
    "jshell"
    "polyglot"
)

# Add GraalVM to the alternatives
for binary in "${binary_graalvm[@]}"
do
    update-alternatives --install /usr/bin/$binary $binary /opt/graalvm/bin/$binary 1
done

# Add JAVA_HOME and PATH to the profile
if [ ! -e $PATH_PROFILE ]; then
    echo "export PATH=/opt/graalvm/bin:\$PATH" | tee -a $PATH_PROFILE
    echo "export JAVA_HOME=/opt/graalvm" | tee -a $PATH_PROFILE
fi




