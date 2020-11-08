PN = "example"

SRC_URI = "file://example.c \
           file://makefile"
S = "${WORKDIR}/${P}"

addtask compile before do_build after do_unpack
