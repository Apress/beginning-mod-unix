#include <pthread.h>
#include <stdio.h>

void* print_alphabet_lowercase(void* pv)
{
    char* pc = (char*) pv;

    for (char ch = *pc; ch <= 'z'; ch++)
    {
        printf("%c\n", ch);
        millisleep();
    }

    return 0;
}

int main()
{
    char starting = 'm';
    pthread_t pth;

    pthread_create(&pth, 0, &print_alphabet_lowercase, &starting);
    pthread_join(pth, 0);
    return 0;
}
