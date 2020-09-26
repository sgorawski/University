from gi.repository import Gtk


class Controls(Gtk.Box):

    def __init__(self, *args, **kwargs):
        super().__init__(spacing=10.0, *args, **kwargs)

        self.reset_btn = Gtk.Button(label="Reset")

        angle_control_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        angle_control_label = Gtk.Label("Angle [0-90 deg]:")
        self.angle_control = Gtk.Entry()
        angle_control_box.pack_start(angle_control_label, False, False, 0)
        angle_control_box.pack_start(self.angle_control, False, False, 0)

        velocity_control_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        velocity_control_label = Gtk.Label("Velocity [pix/sec]:")
        self.velocity_control = Gtk.Entry()
        velocity_control_box.pack_start(
            velocity_control_label, False, False, 0)
        velocity_control_box.pack_start(
            self.velocity_control, False, False, 0)

        self.fire_btn = Gtk.Button(label="Fire!")

        self.pack_start(self.reset_btn, False, False, 10)
        self.pack_start(angle_control_box, False, False, 0)
        self.pack_start(velocity_control_box, False, False, 0)
        self.pack_end(self.fire_btn, False, False, 10)

    def get_angle_and_velocity(self):
        return (
            float(self.angle_control.get_text()),
            float(self.velocity_control.get_text()),
        )
