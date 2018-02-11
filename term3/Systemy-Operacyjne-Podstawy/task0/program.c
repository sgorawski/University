/* Autor: Slawomir Gorawski
*  Zadanie obowiazkowe na pracownie z SO:
*  rozwiazanie problemu czytelnikow i pisarzy
*  2.01.2018
*/

#include <fcntl.h>
#include <stdio.h>
#include <semaphore.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/wait.h>


// PARAMETERS

const int READERS_COUNT = 4;
const int WRITERS_COUNT = 2;
const int SEATS_COUNT = 3;


// SHARED DATA

typedef struct {
    sem_t seats, mutex;
} SharedData;


void shared_data_initialize(SharedData *data) {
    sem_init(&data->seats, 1, SEATS_COUNT);
    sem_init(&data->mutex, 1, 1);
}


void shared_data_destroy(SharedData *data) {
    sem_destroy(&data->seats);
    sem_destroy(&data->mutex);
}

SharedData *shared_data;


// PROCESSES

void reader(int id) {
    for (;;) {
        sem_wait(&shared_data->seats);
        // Reading
        printf("READER %d IS READING\n", id);
        sem_post(&shared_data->seats);
    }
}


void writer(int id) {
    for (;;) {
        sem_wait(&shared_data->mutex);
        for (int i = 0; i < SEATS_COUNT; i++) {
            sem_wait(&shared_data->seats);
        }
        // Writing
        printf("WRITER %d IS WRITING\n", id);
        for (int i = 0; i < SEATS_COUNT; i++) {
            sem_post(&shared_data->seats);
        }
        sem_post(&shared_data->mutex);
    }
}


// MAIN

int main() {
    shared_data = mmap(NULL, sizeof(SharedData), PROT_READ | PROT_WRITE,
                       MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    shared_data_initialize(shared_data);
    pid_t pid;
    int status;

    // Initializing readers
    for (int i = 1; i <= READERS_COUNT; i++) {
        pid = fork();
        if (pid == 0) {
            reader(i);
            return 0;
        }
    }

    // Initializing writers
    for (int i = 1; i <= WRITERS_COUNT; i++) {
        pid = fork();
        if (pid == 0) {
            writer(i);
            return 0;
        }
    }

    // Parent process waiting for children to end
    for (int i = 0; i < READERS_COUNT + WRITERS_COUNT; i++) {
        wait(&status);
    }

    shared_data_destroy(shared_data);
    return 0;
}
