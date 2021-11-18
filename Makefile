# name of your application
APPLICATION = ocaml

# If no BOARD is found in the environment, use this default:
BOARD ?= native

# This has to be the absolute path to the RIOT base directory:
RIOTBASE ?= $(CURDIR)/..

# Comment this out to disable code in RIOT that does safety checking
# which is not needed in a production environment but helps in the
# development process:
DEVELHELP ?= 1

# Change this to 0 show compiler invocation lines by default:
QUIET ?= 0

all: main.c libcamlrun.a



main.c:
	cd example && dune build
	cp example/_build/default/main.c .

CFLAGS += -I$(CURDIR)/ocaml/runtime/

LINKFLAGS += -L$(CURDIR)/ocaml/_build/default/runtime/ -lcamlrun

include $(RIOTBASE)/Makefile.include


ocaml/Makefile:
	sed -i -e 's/oc_cflags="/oc_cflags="$$OC_CFLAGS /g' ocaml/configure
	sed -i -e 's/ocamlc_cflags="/ocamlc_cflags="$$OCAMLC_CFLAGS /g' ocaml/configure

CFLAGS := $(subst \",",$(CFLAGS))
CFLAGS := $(subst ',,$(CFLAGS))
CFLAGS := $(subst -Wstrict-prototypes,,$(CFLAGS))
CFLAGS := $(subst -Werror,,$(CFLAGS))
CFLAGS := $(subst -Wold-style-definition,,$(CFLAGS))
CFLAGS := $(subst -fdiagnostics-color,,$(CFLAGS))
ocaml/Makefile.config: ocaml/Makefile
	cd ocaml && \
		CC="$(CC)" \
		CFLAGS="" \
		AS="$(AS)" \
		ASPP="$(CC) $(CFLAGS) -c" \
		CPPFLAGS="$(CFLAGS)" \
	  ./configure \
		-disable-shared\
		-disable-systhreads\
		-disable-unix-lib\
		-disable-instrumented-runtime
	echo '#undef HAS_SOCKETS' >> ocaml/runtime/caml/s.h
	echo '#undef OCAML_OS_TYPE' >> ocaml/runtime/caml/s.h
	echo '#define OCAML_OS_TYPE "None"' >> ocaml/runtime/caml/s.h

ocaml/runtime/libcamlrun.a: ocaml/Makefile.config
	cd ocaml/ && dune build runtime/libcamlrun.a

libcamlrun.a: ocaml/runtime/libcamlrun.a
