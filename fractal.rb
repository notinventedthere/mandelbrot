require 'cmath'

class Fractal
  def initialize(start_values, formula, coloring_method, palette)
    @start_values = start_values
    @formula = formula
    @coloring_method = coloring_method
    @palette = palette
  end

  def color_at(x, y, max)
    z, c = new_start_values(x, y)
    color_from_palette(@coloring_method.(z, c, max, @formula))
  end


  def color_from_palette(index)
    len = @palette.length - 1
    i = index * len
    while i > len
      i -= len
    end
    floor = @palette[i.floor]
    ceiling = @palette[i.ceil]
    floor.zip(ceiling).map { |(f, c)| (f + (i % 1) * (c - f)).round }
  end

  def new_start_values(x, y)
    @start_values.map { |v| v == :point ? Complex(x, y) : v }
  end
end

module Coloring
  ## All methods should return a color index between 0 and 1
  def self.escape_time
    -> (z, c, max, formula) do
      iterations = 0
      until z.real ** 2 + z.imaginary ** 2 > 10 || iterations == max
        z = formula.(z, c)
        iterations += 1
      end
      (1.0 / max) * iterations
    end
  end

  def self.smooth
    -> (z, c, max, formula) do
      pow = 1.0
      (0..max).each do |i|
        r2 = z.real ** 2 + z.imaginary ** 2
        if r2 > 1000000
          v = Math.log(r2) / pow
          return v
        end
        z = formula.(z, c)
        pow *= 2
      end
      0
    end
  end
end

COLORING_METHODS = {
  escape_time: Coloring.escape_time,
  smooth: Coloring.smooth
}

PALETTES = {
  greyscale: [[65535,65535,65535],[0,0,0],[65535,65535,65535]],
  smooth_greyscale: [[0,0,0],[65535,65535,65535],[40000,40000,40000],*[[0,0,0]].cycle(5)]
}

FRACTALS = {
  mandelbrot: [[0, :point], -> (z, c) { z ** 2 + c }],
  burning_ship: 
    [[0, :point], -> (z, c) { z.real ** 2 - z.imaginary ** 2 - c }],
  julia_1: [[:point, 0.355+0.355i], -> (z, c) { z ** 2 + c }],
  julia_2: [[:point, 0.37+0.1i], -> (z, c) { z ** 2 + c }],
  julia_3: [[:point, -0.54+0.54i], -> (z, c) { z ** 2 + c }],
  sin_z: [[:point, 2], -> (z, c) { c * CMath.sin(z) }],
  cos_z: [[:point, 2], -> (z, c) { c * CMath.cos(z) }]
}
