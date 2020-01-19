CC = gcc
CFLAGS = -Wall -Wextra -std=gnu11 -pthread

program: program.c
	$(CC) $(CFLAGS) program.c -o program

clean:
	rm -f *.o

distclean:
	rm -f *.o program
