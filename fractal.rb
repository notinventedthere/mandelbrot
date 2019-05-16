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
    r, g, b = color_from_palette(@coloring_method.(z, c, max, @formula))
                .map { |c| c.to_s.rjust(3, "0") }
    "##{r}#{g}#{b}"
  end

  private

  def color_from_palette(index)
    len = @palette.length
     i = index * len
    while i > len - 1
      i -= len - 1
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
  def self.escape_time(k=2.5, u0=0)
    -> (z, c, max, formula) do
      iterations = 0
      until z.real ** 2 + z.imaginary ** 2 > 10 || iterations == max
        z = formula.(z, c)
        iterations += 1
      end
      k * (iterations / 20.0 - u0)
    end
  end
end

COLORING_METHODS = {
  escape_time: Coloring.escape_time
}

PALETTES = {
  greyscale: [[0,0,0],[255,255,255],[0,0,0]]
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
