#!/usr/bin/env bash

error_exit() {
    echo "$1" >&2
    exit "${2:-1}"
}

usage() {
    echo "-c clean"
    echo "-b build main"
    echo "-p build python (default)"
    echo "-n don't build python"
    echo "-h print this message"
}

unset JRE_HOME JAVA_BINDIR JAVA_HOME SDK_HOME JDK_HOME JAVA_ROOT
export JAVA_HOME=/usr/java/jdk1.7.0_79
# export JAVA_HOME=/usr/lib/jvm/java/
export ANT_HOME=/usr/share/ant/
export ANT_OPTS="-Xmx2048m -XX:MaxPermSize=384m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/antdump.txt"

clean=false
build=false
test_nb=false
build_python=true

while getopts "cbpnh" opt; do
    case "${opt}" in
        c)
            clean=true;;
        b)
            build=true;;
        p)
            build_python=true;;
        n)
            build_python=false;;
        t)
            test_nb=true;;
	h)
	    usage; exit 0;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$1" && ! -d  "./nbbuild" ]]; then
    cd ~/projects/netbeans
else
    cd "$1"
fi

if "${clean}"; then
    echo "clean"
    echo > /tmp/antdump.txt
    echo > /tmp/ant_clean
    echo > /tmp/ant_mainbuild
    echo > /tmp/ant_pythonbuild
    echo > /tmp/ant_testnb
    ant clean > /tmp/ant_clean 2>&1 || error_exit "ant clean failed"
fi

if "${build}"; then
    echo "build"
    ant build > /tmp/ant_mainbuild 2>&1 || error_exit "ant build failed"
fi

if "${build_python}"; then
    echo "build python"
    ant -Dcluster.config=python build > /tmp/ant_pythonbuild  2>&1 || error_exit "ant -Dcluster.config=python build failed"
fi

if "${test_nb}"; then
    echo "Test nb"
    ant -Dtest.config=commit -Dcontinue.after.failing.tests=true -f o.n.core/build.xml test > /tmp/ant_testnb 2>&1 || exit_error "ant -Dtest.config=commit -Dcontinue.after.failing.tests=true -f o.n.core/build.xml test failed"
fi
