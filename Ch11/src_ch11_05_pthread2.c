#include <pthread.h>
#include <stdio.h>

void* print_alphabet_lowercase(void* pv)
{
    for (char ch = (*((char*) pv)); ch <= 'z'; ch++)
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
    
    for (char ch = 'A'; ch <= 'Z'; ch++)
    {
        printf("%c\n", ch);
        millisleep();
    }

    pthread_join(pth, 0);
    return 0;
}
