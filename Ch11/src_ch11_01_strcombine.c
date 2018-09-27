#include <stdarg.h>
#include <assert.h>
#include <string.h>

char* strcombine(char* dest, const char* src, ...)
{
    assert(dest);
    assert(src);

    const char* p = 0;
    va_list vl;
    
    va_start(vl, src);
    strcpy(dest, src);

    while (p = va_arg(vl, const char*))
    {
        strcat(dest, p);
    }

    va_end(vl);
    return dest;
}

// main() can now use: strcombine(ptr, "Hello", "World1", "World2", 0);
// Note: main() must pre-allocate sufficient memory for ptr
