# Slawomir Gorawski 288653

CC = gcc
CFLAGS = -std=c99 -Wall -Wextra

transport: main.o download.o
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

.PHONY = clean distclean

clean:
	rm -f *.o

distclean: clean
	rm -f transport
