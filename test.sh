#!/bin/sh
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
    echo "update-alternatives --install /usr/bin/$binary $binary /opt/graalvm/bin/$binary 1"
done