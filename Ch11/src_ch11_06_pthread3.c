#include <stdio.h>
#include <pthread.h>

pthread_mutex_t pmt = PTHREAD_MUTEX_INITIALIZER;

void* print_alphabet_lowercase(void* pv)
{
    pthread_mutex_lock(&pmt);               // mutex lock

    for (char ch = (*((char*) pv)); ch <= 'z'; ch++)
    {
        printf("%c\n", ch);
        millisleep();
    }

    pthread_mutex_unlock(&pmt);             // mutex unlock
    return 0;
}

int main()
{
    char starting = 'm';
    pthread_t pth;

    pthread_create(&pth, 0, &print_alphabet_lowercase, &starting);
    pthread_mutex_lock(&pmt);               // mutex lock

    for (char ch = 'A'; ch <= 'Z'; ch++)
    {
        printf("%c\n", ch);
        millisleep();
    }

    pthread_mutex_unlock(&pmt);             // mutex unlock

    pthread_join(pth, 0);
    return 0;
}
