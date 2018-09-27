#include <string.h>
#include <assert.h>

// Unix system headers
#include <sys/stat.h>
#include <sys/file.h>
#include <unistd.h>

int copyfile(const char* infile, const char* outfile)
{
    struct stat filestat;
    int result = stat(infile, &filestat);

    assert(result == 0);
    assert(S_ISREG(filestat.st_mode));
    // In production code, replace assertions with error handling

    const int len = filestat.st_size;

    // For huge files, you'll want to implement a proper data structure.
    // The following approach is fine for illustration though.
    char* buffer = new char[len + 1];
    memset(buffer, 0, len + 1);

    int infd = open(infile, O_RDONLY); // need no mode for O_RDONLY
    int outfd = open(outfile, O_RDWR | O_CREAT, 0644);

    assert(infd > 2); // 0 = stdin; 1 = stdout; 2 = stderr;
    assert(outfd > 2);

    int inpos = 0;
    int outpos = 0;

    while (inpos < len)
    {
        i += read(infd, (char*) (buffer + inpos), len - inpos);
    }

    while (outpos < len)
    {
        j += write(outfd, (char*) (buffer + outpos), len - outpos);
    }

    close(infd);
    close(outfd);

    delete[] buffer;
    buffer = 0;

    // Return error code if needed. The C standard for success is 0:
    return 0;
}
