// Slawomir Gorawski 288653

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <strings.h>
#include <arpa/inet.h>

int download(
	const int sockfd,
	const struct sockaddr_in *server_address,
	const size_t length_server_address,
	const int num_bytes_to_download,
	FILE *out
);

int main(int argc, char *argv[])
{
	if (argc != 5) {
		fputs("Usage: ./transport <IP> <port> <file> <size>\n", stderr);
		return EXIT_FAILURE;
	}

	char *server_ip = argv[1];
	int server_port = atoi(argv[2]);
	char *out_filename = argv[3];
	int size = atoi(argv[4]);

	struct sockaddr_in server_address;
	bzero(&server_address, sizeof server_address);
	server_address.sin_family = AF_INET;
	server_address.sin_port = htons(server_port);
	int ok = inet_pton(AF_INET, server_ip, &server_address.sin_addr);

	if (ok <= 0) {
		if (ok == 0) {
			fputs("invalid IP address\n", stderr);
		} else {
			perror("Error while processing IP");
		}
		return EXIT_FAILURE;
	}

	int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
	if (sockfd < 0) {
		perror("Socket error");
		return EXIT_FAILURE;
	}

	FILE *out = fopen(out_filename, "w");
	if (out == NULL) {
		perror("Could not open output file");
		close(sockfd);
		return EXIT_FAILURE;
	}

	int exit_code = download(
		sockfd,
		&server_address,
		sizeof server_address,
		size,
		out
	);

	close(sockfd);
	fclose(out);

	return exit_code;
}
