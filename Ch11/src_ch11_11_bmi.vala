public class bmiWindow : Gtk.ApplicationWindow
{
    Gtk.Grid grid;
    Gtk.ScrolledWindow scrolled;
    Gtk.TextView view;
    GLib.File? file;
    
    Gtk.Entry entry_name;
    Gtk.CheckButton check_age;
    Gtk.SpinButton spin_height;
    Gtk.Scale scale_weight;
    Gtk.Button button_getbmi;
    Gtk.Button button_savebmi;

    Gtk.Label label_name;
    Gtk.Label label_height;
    Gtk.Label label_weight;
    Gtk.Label label_vala[5];

    public bmiWindow(bmiApplication app)
    {
        Object (application: app, title: "BMI tool");

        this.title = "Body Mass Index tool";
        this.set_default_size(600, 200);
        this.set_border_width(10);

        grid = new Gtk.Grid();
        grid.set_column_spacing(20);
        grid.set_column_homogeneous(true);
        
        label_name = new Gtk.Label ("Name:");
        grid.attach(label_name, 0, 0, 1, 1);

        entry_name = new Gtk.Entry ();
        entry_name.changed.connect(entry_name_changed);
        grid.attach_next_to(entry_name, label_name, Gtk.PositionType.RIGHT);

        check_age = new Gtk.CheckButton.with_label ("Age 20+");
        check_age.set_active(false);
        check_age.toggled.connect(this.check_age_toggled);
        grid.attach_next_to
        (
            check_age, entry_name, Gtk.PositionType.BOTTOM, 1, 1
        );

        label_weight = new Gtk.Label ("Your weight (kg):");
        grid.attach(label_weight, 2, 0, 1, 1);

        scale_weight = new Gtk.Scale.with_range
        (
            Gtk.Orientation.HORIZONTAL, 40, 200, 1.0
        );
        
        scale_weight.set_hexpand(true);
        scale_weight.value_changed.connect(scale_weight_changed);
        grid.attach_next_to
        (
            scale_weight, label_weight, Gtk.PositionType.RIGHT, 1, 1
        );

        label_height = new Gtk.Label ("Your height (cm):");
        grid.attach(label_height, 2, 1, 1, 1);

        spin_height = new Gtk.SpinButton.with_range (140, 200, 1);
        spin_height.set_hexpand(true);
        spin_height.value_changed.connect(spin_height_changed);
        grid.attach_next_to
        (
            spin_height, label_height, Gtk.PositionType.RIGHT, 1, 1
        );

        button_getbmi = new Gtk.Button.with_label("Get BMI");
        button_getbmi.set_sensitive(false);
        button_getbmi.clicked.connect(getbmi_clicked);
        grid.attach(button_getbmi, 3, 3, 1, 1);
        
        scrolled = new Gtk.ScrolledWindow(null, null);
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        
        view = new Gtk.TextView();
        view.set_wrap_mode(Gtk.WrapMode.NONE);
        view.buffer.text = "";
        scrolled.add(view);

        grid.attach(scrolled, 4, 0, 1, 4);

        button_savebmi = new Gtk.Button.with_label("Save as text file");
        button_savebmi.set_sensitive(false);
        button_savebmi.clicked.connect(savebmi_clicked);
        grid.attach(button_savebmi, 4, 4, 1, 1);

        var hseparator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
        grid.attach (hseparator, 0, 4, label_vala.length, 1);

        for (int i = 0; i < label_vala.length; i++)
        {
            label_vala[i] = new Gtk.Label("Powered by Vala");
            label_vala[i].angle = 10;
            label_vala[i].set_pattern    ("           ____");
            grid.attach(label_vala[i], i, 5, 1, 1);
        }

        this.add(grid);
        this.show_all();
    }
    
    void entry_name_changed(Gtk.Editable e)
    {
        check_age.set_active(false);
    }

    void check_age_toggled(Gtk.ToggleButton cb)
    {
        button_savebmi.set_sensitive(false);
        view.buffer.text = "";

        button_getbmi.set_sensitive
        (
            (entry_name.text.length > 0) &&
            (cb.get_active())
        );
    }
    
    void scale_weight_changed(Gtk.Range range)
    {
        view.buffer.text = "";
        button_savebmi.set_sensitive(false);
    }

    void spin_height_changed(Gtk.SpinButton spin)
    {
        view.buffer.text = "";
        button_savebmi.set_sensitive(false);
    }

    void getbmi_clicked(Gtk.Button b)
    {
        double wt = scale_weight.get_value();
        double ht = spin_height.get_value()/100;
        double bmi = wt / (ht * ht);

        string sz = entry_name.text;
        sz += "\n";
        sz += "Weight = %d\n".printf((int) scale_weight.get_value());
        sz += "Height = %d\n".printf((int) spin_height.get_value());
        sz += "BMI = %.2f\n\n".printf(bmi);

        if (bmi > 35) sz += "(Severely obese)";
        if (30   < bmi   <= 35) sz += "(Obese)";
        if (25   < bmi   <= 30) sz += "(Overweight)";
        if (18.5 < bmi   <= 25) sz += "(Healthy weight)";
        if (16   < bmi   <= 18.5) sz += "(Underweight)";
        if (bmi <= 16) sz += "(Severely underweight)";

        view.buffer.text = sz;
        button_savebmi.set_sensitive(true);
    }

    void savebmi_clicked(Gtk.Button b)
    {
        var save_dialog = new Gtk.FileChooserDialog
        (
            "Save BMI report",
            this as Gtk.Window,
            Gtk.FileChooserAction.SAVE,
            Gtk.Stock.CANCEL,
            Gtk.ResponseType.CANCEL,
            Gtk.Stock.SAVE,
            Gtk.ResponseType.ACCEPT
        );

        save_dialog.set_do_overwrite_confirmation(true);
        save_dialog.set_modal(true);

        if (file != null)
        {
            (save_dialog as Gtk.FileChooser).set_file(file);
        }

        save_dialog.response.connect(save_response);
        save_dialog.show();
    }
    
    void save_response(Gtk.Dialog dialog, int response_id)
    {
        var save_dialog = dialog as Gtk.FileChooserDialog;
        
        switch(response_id)
        {
            case Gtk.ResponseType.ACCEPT:
                Gtk.TextIter iter_start;
                Gtk.TextIter iter_end;

                view.buffer.get_bounds(out iter_start, out iter_end);
                file = save_dialog.get_file();
                
                string contents = view.buffer.get_text
                (
                    iter_start, iter_end, false
                );

                file.replace_contents
                (
                    contents.data,
                    null,
                    false,
                    GLib.FileCreateFlags.NONE,
                    null,
                    null
                );

                break;

            case Gtk.ResponseType.CANCEL:
                break;
        }
        
        dialog.destroy();
    }
}

public class bmiApplication : Gtk.Application
{
    public bmiApplication()
    {
        Object(application_id: "org.example.bmiApplication");
    }

    protected override void activate()
    {
        bmiWindow wnd = new bmiWindow(this);
        wnd.show();
    }
}

int main(string[] args)
{
    return new bmiApplication().run(args);
}
