UNAME := $(shell uname -s)
UVERSIS := $(shell uname -v)

CDIR=.
ifeq ($(UVERSIS), 7)
CC = /opt/IBM/xlC/13.1.3/bin/xlC
else
CC = xlC
endif
CFLAGS = -I$(CDIR) `root-config --cflags --libs`
_DEPS = $(CDIR)/OutputVerifier.hh
DEPS = $(patsubst %, $(CDIR)/%, $(_DEPS))

all: $(CDIR)/main.o $(CDIR)/OutputVerifier.o

$(CDIR)/main.o:	$(CDIR)/main.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(CDIR)/OutputVerifier.o:	$(CDIR)/OutputVerifier.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -f $(CDIR)/main.o
	rm -f $(CDIR)/OutputVerifier.o
