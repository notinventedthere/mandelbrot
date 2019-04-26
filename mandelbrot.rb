class Mandelbrot
  attr_reader :inner_color
  attr_reader :colors
  def initialize(inner_color, colors)
    @inner_color = inner_color
    @colors = colors
  end


  def color_at(x, y, max)
    c = Complex(x, y)
    z = 0
    pow = 1.0
    (0..max-1).each do |i|
      r2 = z.real ** 2 + z.imaginary ** 2
      if r2 > 1000000
        v = Math.log(r2) / pow
        if v > 0.5
          return "black"
        else
          return "hsl(#{239*v*2}, 200, #{(0.5-v)*400})"
        end
      end
      z = z ** 2 + c
      pow = pow * 2
    end
    inner_color
  end
end
