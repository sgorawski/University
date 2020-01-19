require_relative 'array'


class Function
  def initialize(form)
    @form = form
  end

  def value(x)
    @form.call(x)
  end

  def root(a, b, e)
    if @form.call(a) * @form.call(b) > 0
      raise ArgumentError, "sign of f(a) must not be equal to sign of f(b)"
    end
    x0 = (a + b) / 2
    if @form.call(x0).abs < e
      return x0 end
    if @form.call(a) * @form.call(x0) < 0
      return self.root(a, x0, e) end
    self.root(x0, b, e)
  end

  def integral(a, b, n=1000)
    dx = (b - a) / n
    sum = 0
    (1..n).each do |i|
      sum += @form.call(a + i * dx) * dx
    end
    sum
  end

  def derivative(x, h=0.00001)
    (@form.call(x + h) - @form.call(x - h)) / (2 * h)
  end

  def generate_plot(a, b, width=400, height=200)
    if a > b
      raise ArgumentError, "a must not be greater than b"
    end

    dx = (b - a) / width
    pixels = Array.new(width) { Array.new(height, false) }
    (0..width - 1).each do |i|
      begin
        h = (@form.call(a + i * dx) / dx).round + height / 2
      rescue FloatDomainError
        h = nil
      end
      if !h.nil? && h >= 0 && h < height
        pixels[i][h] = true
      end
    end
    pixels = pixels.transpose.reverse

    plot = "P1\n#{width.to_s} #{height.to_s}\n" + pixels.to_pbm
    puts "Plot generated"
    plot
  end
end