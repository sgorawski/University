require_relative 'function'


form = lambda { |x| Math.sin(x) }
sinus = Function.new(form)


# FUNCTION - tests
puts sinus.value(12)
puts sinus.root(-0.2, 0.1, 0.001)
puts sinus.integral(0, Math::PI / 2)
puts sinus.derivative(0)


# PLOT - tests
plot = sinus.generate_plot(-Math::PI, Math::PI)
out_file = File.open("chart.pbm", "w")
out_file.puts(plot)
out_file.close
