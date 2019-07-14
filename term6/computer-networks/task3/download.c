// Slawomir Gorawski 288653

#define _DEFAULT_SOURCE

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/select.h>
#include <arpa/inet.h>
#include <netinet/ip.h>

const int MAX_LENGTH = 700;

int send_request(
	const int sockfd,
	const struct sockaddr_in *server_address,
	const size_t length_server_address,
	const int start,
	const int length
)
{
	// here for now

	char msg[30];
	ssize_t length_msg = sprintf(msg, "GET %d %d\n", start, length);

	ssize_t num_bytes_sent = sendto(
		sockfd, msg, length_msg, 0,
		(struct sockaddr *) server_address, length_server_address
	);

	return num_bytes_sent == length_msg;
}

int ip_and_port_match(const struct sockaddr_in *lhs, const struct sockaddr_in *rhs)
{
	if (lhs->sin_port != rhs->sin_port)
		return 0;
	char lhs_ip_str[20], rhs_ip_str[20];
	inet_ntop(AF_INET, &lhs->sin_addr, lhs_ip_str, sizeof lhs_ip_str);
	inet_ntop(AF_INET, &rhs->sin_addr, rhs_ip_str, sizeof rhs_ip_str);
	return strcmp(lhs_ip_str, rhs_ip_str) == 0;
}

int parse_resp(const char *buf, int *start, int *length)
{
	int i = 0;
	while (buf[i++] != ' ');
	*start = atoi(buf + i);

	while (buf[i++] != ' ');
	*length = atoi(buf + i);

	while (buf[i++] != '\n');
	return i;
} 

ssize_t receive_response(
	const int sockfd,
	const struct sockaddr_in *server_address,
	char *buf
)
{
	// here for now

	fd_set descriptors;
	FD_ZERO(&descriptors);
	FD_SET(sockfd, &descriptors);

	struct sockaddr_in sender;
	socklen_t length_sender = (socklen_t) sizeof sender;
	struct timeval timeout = {1, 0};
	ssize_t length_packet;

	do {
		int ready = select(sockfd + 1, &descriptors, NULL, NULL, &timeout);

		if (ready <= 0)
			return ready; // select error or timeout
		
		length_packet = recvfrom(
			sockfd,
			buf,
			IP_MAXPACKET,
			MSG_DONTWAIT,
			(struct sockaddr *) &sender,
			&length_sender
		);

		if (length_packet < 0)
			return length_packet; // recvfrom error
	
	} while (!ip_and_port_match(&sender, server_address));

	return length_packet;
}

int download(
	const int sockfd,
	const struct sockaddr_in *server_address,
	const size_t length_server_address,
	const int num_bytes_to_download,
	FILE *out
)
{
	int num_downloaded_bytes = 0;
	int num_remaining_bytes = num_bytes_to_download;
	char buf[IP_MAXPACKET];

	while (num_remaining_bytes > 0) {
		int length =
			num_remaining_bytes > MAX_LENGTH
			? MAX_LENGTH : num_remaining_bytes;
		int ok = send_request(
			sockfd, server_address, length_server_address,
			num_downloaded_bytes, length
		);
		if (!ok) {
			perror("Error while sending request");
			return EXIT_FAILURE;
		}
		
		ssize_t length_data = receive_response(sockfd, server_address, buf);
		if (length_data < 0) {
			perror("Error while receiving response");
			return EXIT_FAILURE;
		}

		if (length_data == 0) { // timeout
			puts("Timeout");
			continue;
		}

		int length_header, resp_start, resp_length;
		length_header = parse_resp(buf, &resp_start, &resp_length);

		if (resp_start != num_downloaded_bytes || resp_length != length)
			continue;
		
		// success
		num_downloaded_bytes += length;
		num_remaining_bytes -= length;
		fwrite(buf + length_header, sizeof (char), length, out);

		// display progress
		printf("downloaded %d bytes\n", num_downloaded_bytes);
	}

	return EXIT_SUCCESS;
}
