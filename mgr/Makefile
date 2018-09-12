UNAME := $(shell uname -s)
UVERSIS := $(shell uname -v)


CDIR = ../ref
ifeq ($(UVERSIS), 7)
CC = /opt/IBM/xlC/13.1.3/bin/xlC
else
CC = xlC
endif
CFLAGS = -I$(CDIR) `root-config --cflags --libs`
_DEPS = Fort2C.hh
DEPS = $(patsubst %, $(CDIR)/%, $(_DEPS))

all: $(CDIR)/TreeWriter.o $(CDIR)/Fort2C.o

$(CDIR)/Fort2C.o: $(CDIR)/Fort2C.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(CDIR)/TreeWriter.o: $(CDIR)/TreeWriter.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -f $(CDIR)/Fort2C.o
	rm -f $(CDIR)/TreeWriter.o
