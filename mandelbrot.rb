class Mandelbrot
  attr_reader :inner_color
  attr_reader :colors
  def initialize(inner_color, colors)
    @inner_color = inner_color
    @colors = colors
  end


  def color_at(x, y)
    iterations = self.orbit(Complex(x, y)).take(20)
    ind = iterations.find_index { |i| i.real ** 2 + i.imaginary ** 2 > 4 }
    ind ? colors[ind] : inner_color
  end

  def orbit(c)
    Enumerator.unfold(0) do |previous|
      previous ** 2 + c
    end
  end
end

def Enumerator.unfold(start)
  new do |y|
    loop do
      y << start
      start = yield start
    end
  end
end
