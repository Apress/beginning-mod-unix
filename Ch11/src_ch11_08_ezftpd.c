#include "ezftp.h"

#include <pthread.h>
#include <signal.h>

void* send_or_recieve(void* pv)
{
    int datasocket = *((int*) pv);
    
    char cmd[8];
    char filename[256];
    char buffer[1024];
    
    memset(cmd, 0, sizeof(cmd));
    memset(filename, 0, sizeof(filename));
    memset(buffer, 0, sizeof(buffer));
        
    int rcv = read(datasocket, buffer, sizeof(buffer) - 1);

    if (rcv <= 0) // peer closed its socket, perhaps
    {
        return (void*) 1;
    }

    buffer[sizeof(buffer) - 1] = 0;
    buffer[rcv] = 0;

    char* ptr = buffer;
    strncpy(cmd, ptr, 3);       // should be "get" or "put"
    
    ptr += 3;                   // the next byte must be whitespace
    
    if (! isspace(*ptr))
    {
        fprintf(stderr, "Bad command: %s\n", cmd);
        return (void*) 1;
    }        
    
    while(isspace(*ptr) || strchr(ptr, '/'))
    {
        ptr++;
    }

    strcpy(filename, ptr);    
    filename[sizeof(filename) - 1] = 0;
    
    if (! (*filename))
    {
        fprintf(stderr, "Missing file name\n");
        close(datasocket);
        
        return (void*) 1;
    }
    
    if (strcmp(cmd, CMDGET) == 0)
    {
        f_send(datasocket, filename);
    }
    else if (strcmp(cmd, CMDPUT) == 0)
    {
        f_receive(datasocket, filename);
    }
    else
    {
        fprintf(stderr, "Bad command: %s\n", cmd);
        close(datasocket);
        
        return (void*) 1;
    }

    close(datasocket);    
    return (void*) 0;    // return a null pointer on success
}

int main(int argc, char** argv)
{
    int result = 0;
    
    if (argc == 2)
    {
        result = chdir(argv[1]);
        
        if (result != 0)
        {
            fprintf(stderr, "Unable to chdir into %s\n", argv[1]);
            return 1;
        }
    }
    else
    {
        fprintf(stderr, "Need root directory path\n");
        return 1;
    }

    signal(SIGPIPE, SIG_IGN);
    // Guard server from broken pipe resulting from client-side exceptions

    sockaddr_in sv_addr;
    memset((char*) &sv_addr, 0, sizeof(sv_addr));

    sv_addr.sin_family = AF_INET;
    sv_addr.sin_addr.s_addr = INADDR_ANY;
    sv_addr.sin_port = htons(PORT);

    int fd = socket(AF_INET, SOCK_STREAM, 0);
    assert_greater(fd, 2);

    result = bind(fd, (sockaddr*) &sv_addr, sizeof(sv_addr));
    assert_zero(result);

    result = listen(fd, 0);
    assert_zero(result);

    fprintf(stderr, "Accepting connections on port %d\n", PORT);
    fprintf(stderr, "Press Ctrl-C to stop the server\n");

    while (1)
    {
        pthread_t pth;
        sockaddr_in cli_addr;
        
        socklen_t len = sizeof(cli_addr);
        memset((char*) &cli_addr, 0, len);

        int datasocket = accept(fd, (sockaddr*) &cli_addr, &len);
        assert_greater(datasocket, 2);
        
        fprintf
        (
            stdout,
            "Received connection from %s:%d\n",
            inet_ntoa(cli_addr.sin_addr),
            ntohs(cli_addr.sin_port)
        );

        pthread_create(&pth, 0, &send_or_recieve, &datasocket);
    }
    
    close(fd);
    return 0;
}
