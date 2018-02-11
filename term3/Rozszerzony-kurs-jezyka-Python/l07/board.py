from gi.repository import Gtk
from random import randint

from physics import compute_throw


class Board(Gtk.DrawingArea):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.width = 800
        self.height = 600
        self.set_size_request(self.width, self.height)
        self.connect("draw", self.__draw)

        self.ground_height = 20
        self.cannon_x = 50
        self.cannon_size = 20

        self.enemy = self.__Enemy(self.width)
        self.projectile_positions = []

    def reset(self):
        self.enemy = self.__Enemy(self.width)
        self.projectile_positions = []
        self.queue_draw()

    def fire(self, angle, initial_velocity):
        self.projectile_positions = compute_throw(angle, initial_velocity)
        self.queue_draw()
        if (self.enemy.x <=
                self.projectile_positions[-1][0] +
                self.cannon_x + self.cannon_size <=
                self.enemy.x + self.enemy.width):
            return True
        return False

    def __draw(self, da, cr):
        # bounds
        new_width = da.get_allocated_width()
        new_height = da.get_allocated_height()
        self.width, self.height = new_width, new_height

        self.__draw_setup(cr)
        self.__draw_projectile(cr)

    def __draw_setup(self, cr):
        # ground
        cr.rectangle(0,
                     self.height - self.ground_height,
                     self.width,
                     self.ground_height)
        cr.set_source_rgb(0.7, 0.7, 0.7)
        cr.fill()

        # cannon
        cr.rectangle(self.cannon_x,
                     self.height - self.cannon_size,
                     self.cannon_size,
                     self.cannon_size)
        cr.set_source_rgb(0, 0.6, 0)
        cr.fill()

        # enemy
        cr.rectangle(self.enemy.x,
                     self.height - self.enemy.height,
                     self.enemy.width,
                     self.enemy.height)
        cr.set_source_rgb(0.8, 0.1, 0.1)
        cr.fill()

    def __draw_projectile(self, cr):
        cr.set_source_rgb(0.2, 0.2, 0.2)
        cr.set_line_width(1.0)

        initial_x = self.cannon_x + self.cannon_size
        initial_y = self.height - self.ground_height

        x_prev, y_prev = 0, 0
        for x, y in self.projectile_positions:
            cr.move_to(initial_x + x_prev, initial_y - y_prev)
            cr.line_to(initial_x + x, initial_y - y)
            cr.stroke()
            x_prev, y_prev = x, y

    class __Enemy:
        def __init__(self, max_x):
            self.height = 20
            self.width = 100
            self.x = randint(300, max_x - self.width - 1)
