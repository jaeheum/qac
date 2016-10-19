rszshm.o: rszshm/rszshm.c
	$(CC) -c -shared -fPIC -std=gnu11 $< \
	-O \
	-I./rszshm \
	-o $(HOME)/q/l64/rszshm.o

qac.so: qac.c rszshm.o
	$(CC) -DKXVER=3 \
	-D_GNU_SOURCE  \
	-shared -fPIC -std=gnu11 $< -Wall -Wextra \
	-O \
	-I$(HOME)/q/c $(HOME)/q/c/l64/c.o \
	-I./rszshm \
	$(HOME)/q/l64/rszshm.o \
	-o $(HOME)/q/l64/$@

README.md: README.txt
	gitdown $<

notes.md: notes.txt
	gitdown $<

doc: README.md notes.md

all: qac.so

install: all
	cp qac.q $(HOME)/q/qac.q

clean:
	$(RM) $(HOME)/q/l64/qac.so $(HOME)/q/l64/rszshm.o $(HOME)/q/qac.q
