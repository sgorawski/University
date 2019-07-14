# Slawomir Gorawski 288653

CC = gcc
CFLAGS = -std=c99 -Wall -Wextra

traceroute: main.o send.o receive.o
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

.PHONY = clean distclean

clean:
	rm -f *.o

distclean: clean
	rm -f traceroute
