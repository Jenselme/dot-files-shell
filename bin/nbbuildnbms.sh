#!/usr/bin/env bash

if [[ ! -d nbbuild ]]; then
    echo "Launch this in nbbuild dir." >&2
    exit 1
fi

unset JRE_HOME JAVA_BINDIR JAVA_HOME SDK_HOME JDK_HOME JAVA_ROOT
export JAVA_HOME=/usr/java/jdk1.7.0_79
export ANT_HOME=/usr/share/ant/
export ANT_OPTS="-Xmx2048m -XX:MaxPermSize=384m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/antdump.txt -Dcluster.config=python"

pushd contrib
    hg revent -a
    for patchfile in ~/projects/nb-patches/jen-rel/*.patch; do
        echo "Applying patch: ${patchfile}"
        patch -p1 < "${patchfile}"
    done
popd


rm -rf nbbuild/nbms
ant -Dcluster.config=python build-nonsigned-nbms

