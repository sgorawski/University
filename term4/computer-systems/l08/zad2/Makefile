CC = gcc -g
CFLAGS = -Og -Wall
LDFLAGS =
ASFLAGS = -g

all: zad2

zad2: zad2.o lcm_gcd.o

%.stripped: %
	objcopy --strip-all --remove-section .note.gnu.build-id $< $@

zad2.o:
	$(CC) $(CFLAGS) -c zad2.c -o zad2.o

lcm_gcd.o:
	$(CC) $(CFLAGS) -c lcm_gcd.s -o lcm_gcd.o

clean:
	rm -f zad2 *.stripped *.o *~
