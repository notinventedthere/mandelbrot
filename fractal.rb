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
    r, g, b = @palette.((@coloring_method.(z, c, max, @formula))).map { |c| c.to_s.rjust(3, "0") }
    "##{r}#{g}#{b}"
  end

  private

  def new_start_values(x, y)
    @start_values.map { |v| v == :point ? Complex(x, y) : v }
  end
end

module Coloring
  ## Methods which return a float index
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

module Palette
  ## Methods which take a float index and produce a color
  def self.from_colors(colors)
    len = colors.length - 1
    control_points = (0..len).to_a.map { |i| i * (1.0 / len) }
    self.from_control_points(control_points.zip(colors))
  end

  def self.from_control_points(control_points)
    -> (index) do
      index %= 1
      (cp_right, color_right), i_right = control_points.each_with_index.find { |(cp, color), i| index <= cp }
      if cp_right.zero?
        return color_right
      elsif i_right.zero?
        cp_left, color_left = control_points.last
        cp_right += cp_left
      else
        cp_left, color_left = control_points[i_right-1]
      end

      color_left.zip(color_right).map do |l, r|
        self.interpolate(index, cp_left, l, cp_right, r).round
      end
    end
  end

  private

  def self.interpolate(x, x1, y1, x2, y2)
    y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
  end

end

COLORING_METHODS = {
  escape_time: Coloring.escape_time,
  smooth: Coloring.smooth
}

PALETTES = {
  greyscale: Palette.from_colors([[255,255,255],[0,0,0],[255,255,255]]),
  ultra_smooth: Palette.from_control_points(
    [ [0,       [0, 7, 100]],
      [0.16,    [32,  107, 203]],
      [0.42,    [237, 255, 255]],
      [0.6425,  [255, 170, 0]],
      [0.8575,  [0,   2,   0]]
    ]
  )
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
