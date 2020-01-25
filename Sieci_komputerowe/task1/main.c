// Slawomir Gorawski 288653

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <strings.h>
#include <arpa/inet.h>

int send_requests(const int sockfd, const struct sockaddr_in *recipient, const size_t recipient_len, const int ttl);
int receive_responses(const int sockfd, const int ttl, int *is_dest, char *summary);

const int MAX_TTL = 30;

int build_recipient(const char *ip_addr, struct sockaddr_in *recipient, const size_t recipient_len) 
{
	bzero(recipient, recipient_len);
	recipient->sin_family = AF_INET;
	return inet_pton(AF_INET, ip_addr, &recipient->sin_addr);
}

int main(int argc, char **argv)
{
	if (argc != 2) {
		fputs("Usage: ./traceroute <IP>\n", stderr);
		return EXIT_FAILURE;
	}

	struct sockaddr_in recipient;
	int ok = build_recipient(argv[1], &recipient, sizeof recipient);
	if (ok <= 0) {
		if (ok == 0) {
			fputs("Invalid IP address\n", stderr);
		} else {
			perror("Error while processing IP");
		}
		return EXIT_FAILURE;
	}

	const int sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
	if (sockfd < 0) {
		perror("Socket error");
		return EXIT_FAILURE;
	}

	char summary[100];
	for (int err, ttl = 1, is_dest = 0; ttl <= MAX_TTL && !is_dest; ++ttl) {
		err = send_requests(sockfd, &recipient, sizeof recipient, ttl);
		if (err) {
			perror("Error while sending requests");
			return EXIT_FAILURE;
		}

		err = receive_responses(sockfd, ttl, &is_dest, summary);
		if (err) {
			perror("Error while receiving responses");
			return EXIT_FAILURE;
		}
		puts(summary);
	}

	return EXIT_SUCCESS;
}

