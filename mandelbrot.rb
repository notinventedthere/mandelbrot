module Mandelbrot
  def self.colors1(v, limit)
    if v > limit
      "black"
    else
      "hsl(#{239-(200-v*(200/limit))}, 200, #{100-v*(100/limit)}"
    end
  end

  def self.color_at(x, y, max)
    c = Complex(x, y)
    z = 0
    pow = 1.0
    (0..max-1).each do |i|
      r2 = z.real ** 2 + z.imaginary ** 2
      if r2 > 1000000
        v = Math.log(r2) / pow
        return colors1(v, 0.3)
      end
      z = z ** 2 + c
      pow = pow * 2
    end
    "black"
  end
end
