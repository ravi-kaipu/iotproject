SUMMARY = "Recipe to build the 'nano' editor"
PN = "local"

SRC_URI = "file://helloworld.c"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

S = "${WORKDIR}/${P}"

do_configure() {
    echo "Configuring source package ..."
    echo "Configured source package."
}

addtask configure before do_build after do_unpack

do_compile() {
    echo "Compiling package..."
    ${CC} helloworld.c -o helloworld
    echo "Compiled package."
}

addtask compile before do_build after do_configure

do_clean[nostamp] = "1"
do_clean() {
    rm -rf ${WORKDIR}/${P}
    rm -f ${TMPDIR}/stamps/*
}

addtask clean
