require 'cmath'

class Fractal
  MANDELBROT = -> (z, c) { z ** 2 + c }
  BURNING_SHIP = -> (z, c) { z.real ** 2 - z.imaginary ** 2 - c }
  SIN_Z = -> (z, c) { c * CMath.sin(z) }

  def initialize(fractal)
    @fractal = fractal
  end

  def normalize_point(x, y, width, height)
    x = (x - width / 1.6) * 4.0 / width
    y = (y - height / 2.0) * 4.0 / height
    return x, y
  end

  def colors1(v, limit)
    if v > limit # not close enough to M
      "black"
    elsif v > 0.005
      "hsl(#{239-50*Math.sin(((200-v*(200/limit))+50)*v)}, 200, #{80-v*(80/limit)}"
    else
      "hsl(#{189-50*Math.sin(500*v)}, 200, #{80-v*(80/limit)}"
    end
  end

  def color_at(z, c, max)
    pow = 1.0
    (0..max-1).each do |i|
      r2 = z.real ** 2 + z.imaginary ** 2
      if r2 > 1000000
        v = Math.log(r2) / pow
        return colors1(v, 0.3)
      end
      z = @fractal.(z, c)
      pow = pow * 2
    end
    "black"
  end
end
