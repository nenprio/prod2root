CDIR = ../ref
CC = xlC
CFLAGS = -I$(CDIR) `root-config --cflags --libs`
_DEPS = Fort2C.hh
DEPS = $(patsubst %, $(CDIR)/%, $(_DEPS))

$(CDIR)/Fort2C.o: $(CDIR)/Fort2C.cpp $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -f $(CDIR)/Fort2C.o