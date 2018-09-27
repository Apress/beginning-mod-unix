#include <string.h>
#include <assert.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <unistd.h>

#include <time.h>                                   // Copy         *
                                                    // these        |
void millisleep()                                   // lines        |
{                                                   // whereever    |
    struct timespec request;                        // millisleep() |
                                                    // is           |
    request.tv_sec = 0;                             // invoked      |
                                                    // in           |
    request.tv_nsec = 1000 * 1000;                  // the          |
    // 1 = nano; 1000 = micro; 1000 * 1000 = milli  // remainder    |
                                                    // of           |
    nanosleep(&request, 0);                         // this         |
}                                                   // chapter      *

int pipefile(const char* infile, const char* outfile)
{
    const int bs = 4096;
    
    int fd[2];
    pipe(fd);
    
    if (fork())
    {
        close(fd[0]); // parent just writes to the pipe using its fd[1]

        struct stat filestat;
        int result = stat(infile, &filestat);
    
        assert(result == 0);
        assert(S_ISREG(filestat.st_mode));
    
        const int len = filestat.st_size;

        char* buffer = new char[len + 1];
        memset(buffer, 0, len + 1);

        int infd = open(infile, O_RDONLY);
        assert(infd > 2);

        int iread = 0;
        
        while (iread < len)
        {
            iread += read(infd, (char*) (buffer + iread), len - iread);
        }

        close(infd);
        int written = 0;
        
        while (written < len)
        {
            int iwrite = 0;
            int to_write = ((len - written) >= bs) ? bs : len - written;
            
            while (iwrite < to_write)
            {
                iwrite += write
                (
                    fd[1],
                    (char*) (buffer + written + iwrite),
                    to_write - iwrite
                );
            }

            written += to_write;
            millisleep();
        }
        
        delete[] buffer;
        buffer = 0;

        close(fd[1]);
    }
    else
    {
        close(fd[1]); // child just needs to read the pipe using its fd[0]
        
        int outfd = open(outfile, O_RDWR | O_CREAT, 0644);
        assert(outfd > 2);
        
        char* buffer = new char[bs + 1];
        
        while (1)
        {
            memset(buffer, 0, bs + 1);
            int oread = read(fd[0], (char*) buffer, bs);
            
            if (oread <= 0)
            {
                break;
            }
            
            int owrite = 0;
            
            while (owrite < oread)
            {
                owrite += write
                (
                    outfd,
                    (char*) (buffer + owrite),
                    oread - owrite
                );
            }
        }
    
        close(outfd);
        close(fd[0]);
        
        delete[] buffer;
        buffer = 0;
    }

    return 0;
}
