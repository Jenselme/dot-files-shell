#!/usr/bin/env bash

error_exit() {
    echo "$1" >&2
    exit "${2:-1}"
}

unset JRE_HOME JAVA_BINDIR JAVA_HOME SDK_HOME JDK_HOME JAVA_ROOT
export JAVA_HOME=/usr/lib64/jvm/java-1.7.0-openjdk
export ANT_HOME=/usr/share/ant/
export ANT_OPTS="-Xmx960m -XX:MaxPermSize=192m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/antdump.txt"

clean=false
build=false
build_python=true

while getopts "cbpn" opt; do
    case "${opt}" in
        c)
            clean=true;;
        b)
            build=true;;
        p)
            build_python=true;;
        n)
            build_python=false;;
    esac
done
shift $((OPTIND-1))

cd ~/netbeans

if "${clean}"; then
    echo "clean"
    ant clean > /tmp/ant_clean 2>&1 || error_exit "ant clean failed"
fi

if "${build}"; then
    echo "build"
    ant build > /tmp/ant_mainbuild 2>&1 || error_exit "ant build failed"
fi

if "${build_python}"; then
    echo "build python"
    ant -Dcluster.config=python build > /tmp/ant_pythonbuild || error_exit "ant -Dcluster.config=python build failed"
fi
