import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

from controls import Controls
from board import Board


class MainWindow(Gtk.Window):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.connect("delete-event", Gtk.main_quit)

        root_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)

        self.board = Board()
        self.controls = Controls()
        self.console = Gtk.Label("Input angle, initial velocity and fire!")

        self.controls.reset_btn.connect("clicked", self.__on_reset_clicked)
        self.controls.fire_btn.connect("clicked", self.__on_fire_clicked)

        root_box.pack_start(self.board, False, False, 0)
        root_box.pack_end(self.controls, False, False, 10)
        root_box.pack_end(self.console, False, False, 10)

        self.add(root_box)

    def __on_reset_clicked(self, button):
        self.board.reset()
        self.controls.angle_control.set_text('')
        self.controls.velocity_control.set_text('')
        self.console.set_text("Input angle, initial velocity and fire!")

    def __on_fire_clicked(self, button):
        try:
            angle, velocity = self.controls.get_angle_and_velocity()
            if not 0 <= angle <= 90:
                raise ValueError("angle must be between 0 and 90")
            hit = self.board.fire(angle, velocity)
            msg = "HIT!" if hit else "Missed"
            self.console.set_text(msg)
        except ValueError as e:
            self.console.set_text("Wrong values: %s" % e)


win = MainWindow(title="Cannonball")
win.show_all()
Gtk.main()
