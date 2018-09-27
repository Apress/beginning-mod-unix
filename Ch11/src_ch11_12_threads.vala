class MyThread
{
    private int maxcount;

    public MyThread(int _maxcount)
    {
        this.maxcount = _maxcount;
    }

    public void* run()
    {
        int counter = 0;

        while (counter < this.maxcount)
        {
            stdout.printf("%d\n", counter);
            counter++;
            
            Thread.usleep(100000);
        }

        return (void*) Thread.self;
    }
}

int main()
{
    if (! Thread.supported())
    {
        stderr.printf("Cannot run without thread support\n");
        return 1;
    }

    message("MAIN THREAD: %p", (void*) Thread.self);
    
    try
    {
        var mythr = new MyThread(8);

        Thread<void*> thr = new Thread<void*>.try
        (
            "Spawned thread", mythr.run
        );

        thr.join();
    }
    catch(Error e)
    {
        stderr.printf("%s\n", e.message);
        return 1;
    }

    return 0;
}
