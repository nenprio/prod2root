UNAME := $(shell uname -s)
UVERSIS := $(shell uname -v)

ifeq ($(UVERSIS), 7)
	CC = /opt/IBM/xlC/13.1.3/bin/xlC
else
	CC = xlC
endif
CFLAGS = -I. `root-config --cflags --libs`

main.o: main.cpp src/MyFunctions.cpp src/RootExplorer.cpp
	$(CC) -o $@ $< src/MyFunctions.cpp src/RootExplorer.cpp $(CFLAGS)

clean:
	rm -f main.o
