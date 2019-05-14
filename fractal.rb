require 'cmath'

class Fractal
  def initialize(start_values, formula)
    @start_values = start_values
    @formula = formula
  end

  def self.normalize_point(x, y, width, height, scale=1)
    x = (x - width / 1.6) * 4.0 / scale / width
    y = (y - height / 2.0) * 4.0 / scale / height
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

  def color_at(point, max)
    z, c = @start_values
    z = point if z == :point
    c = point if c == :point
    pow = 1.0
    (0..max-1).each do |i|
      r2 = z.real ** 2 + z.imaginary ** 2
      if r2 > 1000000
        v = Math.log(r2) / pow
        return colors1(v, 0.3)
      end
      z = @formula.(z, c)
      pow = pow * 2
    end
    "black"
  end
end

FRACTALS = {
  ## name: [start_values, function to iterate]
  mandelbrot: [[0, :point],
               -> (z, c) { z ** 2 + c }],
  burning_ship: [[0, :point],
                 -> (z, c) { z.real ** 2 - z.imaginary ** 2 - c }],
  julia_1: [[:point, 0.355+0.355i],
            -> (z, c) { z ** 2 + c }],
  sin_z: [[:point, 2],
          -> (z, c) { c * CMath.sin(z) }],
  cos_z: [[:point, 2],
          -> (z, c) { c * CMath.cos(z) }]
}
