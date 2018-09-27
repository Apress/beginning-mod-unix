#ifndef EZFTP_H
#define EZFTP_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <new>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>

const int PORT = 6666;
const long MB = 1024*1024;

const char* CMDGET = "get";
const char* CMDPUT = "put";

int assert_zero(long n)
{
    if (n != 0)
    {
        fprintf(stderr, "Runtime check (n == 0) failed\n");
        exit(-1);
    }
    
    return 0;
}

int assert_greater(long n, long floor)
{
    if (n <= floor)
    {
        fprintf(stderr, "Runtime check (n > floor) failed\n");
        exit(-1);
    }
    
    return 0;
}

int f_receive(int datasocket, const char* infile)
{
    int fd = open(infile, O_RDWR | O_CREAT, 0644);
    assert_greater(fd, 2);

    int written = 0;
    
    while (1)
    {
        char* pbuffer = new(std::nothrow) char[MB];
        assert_greater((long) pbuffer, 0);

        memset(pbuffer, 0, MB);

        int result = 0;
        int iwritten = 0;   // written during this iteration

        int iread = read(datasocket, pbuffer, MB);
        
        if (iread <= 0)
        {
            delete[] pbuffer;
            pbuffer = 0;

            break;
        }

        while (iwritten < iread)
        {
            result = write
            (
                fd,
                (char*) (pbuffer + iwritten),
                iread - iwritten
            );
            
            assert_greater(result, 0);
            iwritten += result;
        }
        
        written += iwritten;
        delete[] pbuffer;
        pbuffer = 0;
    }
    
    close(fd);
    return written;
}

int f_send(int datasocket, const char* infile)
{
    struct stat filestat;
    int result = lstat(infile, &filestat);
    
    if ((result != 0) || (! S_ISREG(filestat.st_mode)))
    {
        fprintf(stderr, "Bad filename: %s\n", infile);
        return -1;
    }

    const int len = filestat.st_size;
    int fd = open(infile, O_RDONLY);
    assert_greater(fd, 2);

    int written = 0;

    while (written < len)
    {
        char* pbuffer = new(std::nothrow) char[MB];
        assert_greater((long) pbuffer, 0);

        memset(pbuffer, 0, MB);
        result = 0;

        int iread = 0;      // read during this iteration
        int iwritten = 0;   // written during this iteration
        
        const int to_read = (len - written >= MB) ? MB : len - written;
        const int to_write = to_read;

        while (iread < to_read)
        {
            result = read
            (
                fd,
                (char*) (pbuffer + iread),
                to_read - iread
            );

            assert_greater(result, 0);
            iread += result;
        }

        while (iwritten < to_write)
        {
            result = write
            (
                datasocket,
                (char*) (pbuffer + iwritten),
                to_write - iwritten
            );

            if (result <= 0)
            {
                delete[] pbuffer;
                pbuffer = 0;
                close(fd);
                return -1;
            }
            
            iwritten += result;
        }

        written += to_write;
        delete[] pbuffer;
        pbuffer = 0;
    }

    close(fd);
    return written;
}

#endif
