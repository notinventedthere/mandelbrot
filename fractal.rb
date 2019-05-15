require 'cmath'

class Fractal
  def initialize(start_values, formula)
    @start_values = start_values
    @formula = formula
  end

  def color_at(x, y, max)
    red, green, blue = color_palette(color_index(iteration_coloring(x, y, max), 2.5, 0), GREY_PALETTE)
    "##{red.round}#{green.round}#{blue.round}"
  end

  private

  def color_palette(index, palette)
    i = index * 100
    while i > 99
      i -= 99
    end
    floor = palette[i.floor]
    ceiling = palette[i.ceil]
    diffs = ceiling.zip(floor).map { |(x, y)| (i % 1) * (x - y) }
    floor.zip(diffs).map(&:sum)
  end

  grey_palette = 50.downto(1).map { |x| [x * (255 / 50.0)].cycle(3) }
  GREY_PALETTE = grey_palette + grey_palette.reverse

  def color_index(coloring, k, u0)
    k * (coloring - u0)
  end

  def iteration_coloring(x, y, max)
    z, c = new_start_values(x, y)
    iterations = 0
    until z.real ** 2 + z.imaginary ** 2 > 10 || iterations == max
      z = @formula.(z, c)
      iterations += 1
    end
    iterations / 20.0
  end

  def new_start_values(x, y)
    @start_values.map { |v| v == :point ? Complex(x, y) : v }
  end
end

FRACTALS = {
  mandelbrot: Fractal.new([0, :point], -> (z, c) { z ** 2 + c }),
  burning_ship: 
    Fractal.new([0, :point], -> (z, c) { z.real ** 2 - z.imaginary ** 2 - c }),
  julia_1: Fractal.new([:point, 0.355+0.355i], -> (z, c) { z ** 2 + c }),
  julia_2: Fractal.new([:point, 0.37+0.1i], -> (z, c) { z ** 2 + c }),
  julia_3: Fractal.new([:point, -0.54+0.54i], -> (z, c) { z ** 2 + c }),
  sin_z: Fractal.new([:point, 2], -> (z, c) { c * CMath.sin(z) }),
  cos_z: Fractal.new([:point, 2], -> (z, c) { c * CMath.cos(z) })
}
