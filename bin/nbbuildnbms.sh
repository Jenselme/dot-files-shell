#!/usr/bin/env bash

set -u
set -e

if [[ ! -d nbbuild ]]; then
    echo "Launch this in nbbuild dir." >&2
    exit 1
fi

unset JRE_HOME JAVA_BINDIR JAVA_HOME SDK_HOME JDK_HOME JAVA_ROOT
export JAVA_HOME=/usr/lib/jvm/java/
export ANT_HOME=/usr/share/ant/
export ANT_OPTS="-Xmx2048m -XX:MaxPermSize=384m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/antdump.txt -Dcluster.config=python"

hg revert -a
for patchfile in ../netbeans-releases-patch/*.patch; do
    echo "Applying patch on NetBeans: ${patchfile}"
    patch -p1 < "${patchfile}"
done

pushd contrib
    hg revert -a
    if ls ~/projects/nb-patches/jen-rel/*.patch 2> /dev/null; then
    	for patchfile in ~/projects/nb-patches/jen-rel/*.patch; do
        	echo "Applying patch on contrib: ${patchfile}"
        	patch -p1 < "${patchfile}"
    	done
    fi
popd


rm -rf nbbuild/nbms
ant -Dcluster.config=python build-nonsigned-nbms

