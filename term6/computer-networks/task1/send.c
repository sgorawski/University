// Slawomir Gorawski 288653

#include <assert.h>
#include <unistd.h>
#include <netinet/ip_icmp.h>
#include <netinet/in.h>

const int NUM_REQUESTS = 3;

u_int16_t compute_icmp_checksum(const void *buff, int length)
{
	u_int32_t sum;
	const u_int16_t *ptr = buff;
	assert (length % 2 == 0);
	for (sum = 0; length > 0; length -= 2)
		sum += *ptr++;
	sum = (sum >> 16) + (sum & 0xffff);
	return (u_int16_t) ~(sum + (sum >> 16));
}

void build_header(struct icmphdr *header, const size_t header_len, const int seq)
{
	header->type = ICMP_ECHO;
	header->code = 0;
	header->un.echo.id = getpid();
	header->un.echo.sequence = seq;
	header->checksum = 0;
	header->checksum = compute_icmp_checksum((uint16_t *) header, header_len);
}

int send_requests(const int sockfd, const struct sockaddr_in *recipient, const size_t recipient_len, const int ttl)
{
	setsockopt(sockfd, IPPROTO_IP, IP_TTL, &ttl, sizeof (int));
	struct icmphdr header;

	for (int i = 0; i < NUM_REQUESTS; ++i) {
		int seq = NUM_REQUESTS * ttl + i;
		build_header(&header, sizeof header, seq);

		ssize_t bytes_sent = sendto(
			sockfd,
			&header,
			sizeof header,
			0,
			(struct sockaddr *) recipient,
			recipient_len
		);

		if (bytes_sent < 0)
			return bytes_sent;
	}
	return 0;
}

