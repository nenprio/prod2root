UNAME := $(shell uname -s)
UVERSIS := $(shell uname -v)


CDIR = ../ref
ifeq ($(UVERSIS), 7)
#CC = /opt/IBM/xlC/13.1.3/bin/xlC
CC = /opt/IBM/xlC/13.1.3/bin/xlC -g
else
# CC = xlC
CC = xlC -g
endif
CFLAGS = -I$(CDIR) `root-config --cflags --libs`

all: $(CDIR)/TreeWriter.o $(CDIR)/Fort2C.o

$(CDIR)/Fort2C.o: $(CDIR)/Fort2C.cpp $(CDIR)/Fort2C.hh
	$(CC) -c -o $@ $< $(CFLAGS)

$(CDIR)/TreeWriter.o: $(CDIR)/TreeWriter.cpp $(CDIR)/TreeWriter.hh $(CDIR)/Struct.hh
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -f $(CDIR)/*.o
