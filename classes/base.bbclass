BB_DEFAULT_TASK ?= "build"

inherit utils

OE_IMPORTS += "os sys time oe.path oe.utils oe.data oe.packagegroup"
OE_IMPORTS[type] = "list"


die() {
	bbfatal "$*"
}


FILESPATH = "${@base_set_filespath([ "${FILE_DIRNAME}/${PF}", "${FILE_DIRNAME}/${P}", "${FILE_DIRNAME}/${PN}", "${FILE_DIRNAME}/files", "${FILE_DIRNAME}" ], d)}"
# THISDIR only works properly with imediate expansion as it has to run
# in the context of the location its used (:=)
THISDIR = "${@os.path.dirname(d.getVar('FILE', d, True))}"


oe_runmake() {
	if [ x"$MAKE" = x ]; then MAKE=make; fi
	${MAKE} ${EXTRA_OEMAKE} "$@" || die "oe_runmake failed"
}

addtask fetch
do_fetch[dirs] = "${DL_DIR}"
python base_do_fetch() {
    src_uri = (d.getVar('SRC_URI', d, True) or "").split()
    if len(src_uri) == 0:
        return

    localdata = d.createCopy()
    bb.data.update_data(localdata)

    fetcher = bb.fetch2.Fetch(src_uri, localdata)
    fetcher.download()
}


addtask unpack after do_fetch
do_unpack[dirs] = "${WORKDIR}/${P}"
python base_do_unpack() {
    src_uri = (d.getVar('SRC_URI', d, True) or "").split()
    if len(src_uri) == 0:
        return

    localdata = d.createCopy()
    bb.data.update_data(localdata)

    rootdir = d.getVar('WORKDIR', localdata, True)
    folder = d.getVar('P', localdata, True)

    fetcher = bb.fetch2.Fetch(src_uri, localdata)
    fetcher.unpack(os.path.join(rootdir, folder))
}

addtask configure after do_unpack
do_configure[dirs] = "${CCACHE_DIR} ${S} ${B}"
do_configure[deptask] = "do_populate_sysroot"
base_do_configure() {
	:
}

addtask compile after do_configure
do_compile[dirs] = "${S} ${B}"
base_do_compile() {
	if [ -e Makefile -o -e makefile ]; then
		oe_runmake || die "make failed"
	fi
}

addtask install after do_compile
do_install[dirs] = "${D} ${S} ${B}"
# Remove and re-create ${D} so that is it guaranteed to be empty
do_install[cleandirs] = "${D}"

base_do_install() {
	:
}

base_do_package() {
	:
}

addtask build
do_build = ""
do_build[func] = "1"
do_build[noexec] = "1"
do_build[recrdeptask] += "do_deploy"
do_build () {
	:
}

addtask cleansstate after do_clean
python do_cleansstate() {
        sstate_clean_cachefiles(d)
}

addtask cleanall after do_cleansstate
python do_cleanall() {
        src_uri = (bb.data.getVar('SRC_URI', d, True) or "").split()
        if len(src_uri) == 0:
            return

    localdata = bb.data.createCopy(d)
    bb.data.update_data(localdata)

        try:
            fetcher = bb.fetch2.Fetch(src_uri, localdata)
            fetcher.clean()
        except bb.fetch2.BBFetchException, e:
            raise bb.build.FuncFailed(e)
}
do_cleanall[nostamp] = "1"


EXPORT_FUNCTIONS do_fetch do_unpack do_configure do_compile do_install do_package
