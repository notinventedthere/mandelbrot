class Mandelbrot
  attr_reader :inner_color
  attr_reader :colors
  def initialize(inner_color, colors)
    @inner_color = inner_color
    @colors = colors
  end


  def color_at(x, y, max)
    c = Complex(x, y)
    previous = 0
    (0..max-1).each do |i|
      previous = previous ** 2 + c
      return colors[i] if previous.real ** 2 + previous.imaginary ** 2 > 4
    end
    inner_color
  end
end
