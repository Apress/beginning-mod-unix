#include "ezftp.h"

int handshake(int datasocket, const char* protocol, const char* infile)
{
    int i = 0;
    int result = 0;
    char cmd[1024];
    
    strcpy(cmd, protocol);          // protocol can be "get" or "put"
    strcat(cmd, " ");
    strcat(cmd, infile);

    cmd[sizeof(cmd) - 1] = 0;
    const int cmdlen = strlen(cmd);
    
    while (i < cmdlen)
    {
        result = write(datasocket, (char*) (cmd + i), cmdlen - i);
        assert_greater(result, 0);
        i += result;
    }

    return 0;    
}

int main(int argc, char** argv)
{
    bool failed = false;
    
    if (argc == 4)
    {
        // First ensure that server IP/command/filename are not empty:
        for (int i = 1; i < argc; i++)
        {
            if (! *(argv[i]))
            {
                failed = true;
                break;
            }
        }
        
        if ((strcmp(argv[2], CMDGET) != 0) && (strcmp(argv[2], CMDPUT) != 0))
        {
            failed = true;
        }
    }
    else
    {
        failed = true;
    }

    if (failed)
    {
        fprintf(stderr, "Usage: ezftp <server IP> <command> <filename>\n");
        fprintf(stderr, "<command> can be get or put\n");
        return 1;
    }
    
    sockaddr_in addr;
    
    memset((char*) &addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr(argv[1]);
    addr.sin_port = htons(PORT);

    int datasocket = socket(AF_INET, SOCK_STREAM, 0);
    assert_greater(datasocket, 2);

    int result = connect(datasocket, (sockaddr*) &addr, sizeof(addr));
    assert_zero(result);

    if (strcmp(argv[2], CMDGET) == 0)
    {
        result = handshake(datasocket, CMDGET, argv[3]);
        assert_zero(result);

        f_receive(datasocket, argv[3]);
    }
    else if (strcmp(argv[2], CMDPUT) == 0)
    {
        result = handshake(datasocket, CMDPUT, argv[3]);
        assert_zero(result);

        f_send(datasocket, argv[3]);
    }
    else
    {
        fprintf(stderr, "Bad command: %s %s %s\n", argv[1], argv[2], argv[3]);
        close(datasocket);
        return 1;
    }

    close(datasocket);
    return 0;
}
