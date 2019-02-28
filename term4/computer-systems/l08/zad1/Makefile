CC = gcc -g
CFLAGS = -Og -Wall
LDFLAGS =
ASFLAGS = -g

all: zad1

zad1: zad1.o clz.o

%.stripped: %
	objcopy --strip-all --remove-section .note.gnu.build-id $< $@

zad1.o:
	$(CC) $(CFLAGS) -c zad1.c -o zad1.o

clz.o:
	$(CC) $(CFLAGS) -c clz.s -o clz.o

clean:
	rm -f zad1 *.stripped *.o *~
