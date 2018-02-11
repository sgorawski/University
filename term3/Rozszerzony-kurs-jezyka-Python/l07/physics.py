from math import sin, cos, radians


def compute_throw(angle, initial_velocity, delta_time=0.1):
    g = 9.81
    angle_rad = radians(angle)
    t = delta_time
    y = 1

    projectile_positions = []
    while y > 0:
        x = initial_velocity * t * cos(angle_rad)
        y = initial_velocity * t * sin(angle_rad) - g * t**2 / 2
        projectile_positions.append((x, y))
        t += delta_time

    # optimization
    if len(projectile_positions) > 2 and projectile_positions[-1][-1] < 0:
        x1, y1 = projectile_positions[-2]
        x2, y2 = projectile_positions[-1]
        frac = abs((y1 - 0)/(y2 - y1))
        x2 = x1 + abs(x2 - x1)*frac
        projectile_positions.pop()
        projectile_positions.append((x2, 0))

    return projectile_positions
