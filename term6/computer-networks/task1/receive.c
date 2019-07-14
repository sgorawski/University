// Slawomir Gorawski 288653

#define _DEFAULT_SOURCE

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <arpa/inet.h>
#include <sys/select.h>
#include <sys/time.h>

extern const int NUM_REQUESTS;

static int id_and_seq_match(const struct icmphdr * resp_icmphdr, const int ttl)
{
	const struct icmphdr *icmphdr_to_check;

	if (resp_icmphdr->type == ICMP_ECHOREPLY) {
		icmphdr_to_check = resp_icmphdr;
	} else if (resp_icmphdr->type == ICMP_TIME_EXCEEDED) {
		// ICMP Time Exceeded packet contains:
		// 1 byte of type, 1 byte of code, 2 bytes of checksum and 4 bytes unused,
		// then original IP header and original data, which we want,
		// so first we throw away first 8 bytes to access original IP header.
		struct iphdr *orig_iphdr = (struct iphdr *) ((uint8_t *) resp_icmphdr + 8);
		// and now we extract ICMP data after the original IP header
		icmphdr_to_check = (struct icmphdr *) ((uint8_t *) orig_iphdr + 4 * orig_iphdr->ihl);
	} else {
		// should never happen
		return -1;
	}

	return (
		icmphdr_to_check->un.echo.id == getpid()
		&& icmphdr_to_check->un.echo.sequence / 3 == ttl
	);
}

void build_summary(int ttl, int num_responses, char sender_ip_addrs[3][20], int avg_time_ms, char *summary)
{
	// make receive_responses modify a struct pointer with all the data
	// and move this to main?
	int offset = sprintf(summary, "%d. ", ttl);
	
	if (num_responses == 0) {
		strcat(summary, "*");
		return;
	}

	offset += sprintf(summary + offset, "%s ", sender_ip_addrs[0]);

	if (num_responses >= 2 && strcmp(sender_ip_addrs[0], sender_ip_addrs[1]) != 0)
		offset += sprintf(summary + offset, "%s ", sender_ip_addrs[1]);
	
	if (num_responses == 3 && (
		strcmp(sender_ip_addrs[0], sender_ip_addrs[2]) != 0
		|| strcmp(sender_ip_addrs[1], sender_ip_addrs[2]) != 0
	))
		offset += sprintf(summary + offset, "%s ", sender_ip_addrs[2]);

	if (num_responses == 3) {
		sprintf(summary + offset, "%dms", avg_time_ms);
	} else {
		strcat(summary, "???");
	}
}

int get_avg_resp_time_ms(struct timeval *beginning, struct timeval *resp_times, int resp_times_len)
{
	struct timeval diff = {0}, total = {0};
	for (int i = 0; i < resp_times_len; ++i) {
		timersub(&resp_times[i], beginning, &diff);
		timeradd(&total, &diff, &total);
	}
	return (1000 * total.tv_sec + total.tv_usec / 1000) / resp_times_len;
}

int receive_responses(const int sockfd, const int ttl, int *is_dest, char *summary)
{
	fd_set descriptors;
	FD_ZERO(&descriptors);
	FD_SET(sockfd, &descriptors);

	struct timeval beginning;
	gettimeofday(&beginning, NULL);
	struct timeval timeout = {1, 0};
	struct timeval resp_times[3];

	struct sockaddr_in sender;
	socklen_t sender_len = (socklen_t) sizeof sender;
	uint8_t buf[IP_MAXPACKET];

	int avg_time_ms = 0;
	int num_responses = 0;
	char sender_ip_addrs[3][20];

	while (num_responses < NUM_REQUESTS) {
		int ready = select(sockfd + 1, &descriptors, NULL, NULL, &timeout);

		if (ready < 0)
			// select error
			return ready;

		if (ready == 0)
			// timeout
			break;

		ssize_t packet_len = recvfrom(
			sockfd,
			buf,
			IP_MAXPACKET,
			MSG_DONTWAIT,
			(struct sockaddr *) &sender,
			&sender_len
		);

		if (packet_len < 0)
			// recvfrom error
			return packet_len;
		
		gettimeofday(&resp_times[num_responses], NULL);

		struct iphdr *resp_iphdr = (struct iphdr *) buf;
		struct icmphdr *resp_icmphdr = (struct icmphdr *) (buf + 4 * resp_iphdr->ihl);
		
		if (!id_and_seq_match(resp_icmphdr, ttl))
			// ignore this response
			continue;
		
		*is_dest = resp_icmphdr->type == ICMP_ECHOREPLY;

		inet_ntop(AF_INET, &sender.sin_addr, sender_ip_addrs[num_responses], 20);
		++num_responses;
	}

	if (num_responses == NUM_REQUESTS)
		avg_time_ms = get_avg_resp_time_ms(&beginning, resp_times, NUM_REQUESTS);

	build_summary(ttl, num_responses, sender_ip_addrs, avg_time_ms, summary);

	return 0;
}

