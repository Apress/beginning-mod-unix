public class hwWindow : Gtk.ApplicationWindow
{
    public hwWindow(hwApplication app)
    {
        Object(application: app, title: "Hello World");
        
        var button = new Gtk.Button.with_label("Click Here");
        button.clicked.connect(this.button_clicked);

        this.window_position = Gtk.WindowPosition.CENTER;
        this.set_default_size(300, 60);
        this.add(button);
        
        this.show_all();
    }

    void button_clicked(Gtk.Button button)
    {
        string msg = "Hello World!".reverse();
        
        var dialog = new Gtk.MessageDialog
        (
            this,
            Gtk.DialogFlags.MODAL,
            Gtk.MessageType.INFO,
            Gtk.ButtonsType.OK,
            msg
        );

        dialog.response.connect(() =>
        {
            dialog.destroy();
        });
        
        dialog.show();
    }
}

public class hwApplication : Gtk.Application
{
    public hwApplication()
    {
        Object(application_id: "org.example.HelloWorld");
    }

    protected override void activate()
    {
        (new hwWindow(this)).show();
    }
}

int main()
{
    return (new hwApplication()).run();
}
