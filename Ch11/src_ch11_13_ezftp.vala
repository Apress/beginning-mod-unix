using GLib;

int main(string[] args)
{
    if (args.length != 3)
    {
        stderr.printf("Need 2 args: <server name or IP> <downfile>\n");
        return 1;
    }

    Resolver resolver = Resolver.get_default();
    List<InetAddress> addresses = resolver.lookup_by_name(args[1], null);

    InetSocketAddress inetsock = new InetSocketAddress
    (
        addresses.nth_data(0),
        6666
    );
    
    SocketClient client = new SocketClient();
    SocketConnection conn = client.connect(inetsock);
    DataInputStream response = new DataInputStream(conn.input_stream);

    var file = File.new_for_path(args[2]);
    
    string message = "get ";
    message += args[2];
    conn.output_stream.write(message.data);

    var dos = new DataOutputStream
    (
        file.create(FileCreateFlags.REPLACE_DESTINATION)
    );

    while (! conn.is_closed())
    {
        uint8 byte = 0;
    
        try
        {
            byte = response.read_byte();
        }
        catch(IOError e)
        {
            break;
        }
        
        dos.put_byte(byte);
    }
    
    dos.close();
    return 0;
}
