# frozen_string_literal: true

require 'cmath'

class Fractal
  def initialize(start_values, formula, palette)
    @start_values = start_values
    @formula = formula
    @palette = palette
  end

  def color_at(x, y, max)
    z, c = new_start_values(x, y)
    @palette.call(z, c, max, @formula)
  end

  private

  def new_start_values(x, y)
    @start_values.map { |v| v == :point ? Complex(x, y) : v }
  end
end

module FractalMethod
  ## Methods which return a float index
  def self.escape_time
    lambda do |z, c, max, formula|
      iterations = 0
      until z.real**2 + z.imaginary**2 > 10 || iterations == max
        z = formula.call(z, c)
        iterations += 1
      end
      (1.0 / max) * iterations
    end
  end

  def self.smooth
    lambda do |z, c, max, formula|
      pow = 1.0
      (0..max).each do |_i|
        r2 = z.real**2 + z.imaginary**2
        return Math.log(r2) / pow if r2 > 1_000_000

        z = formula.call(z, c)
        pow *= 2
      end
      0
    end
  end
end

module Palette
  # Methods which return a lambda that
  # takes a float index and produces a color
  def self.from_colors(colors)
    len = colors.length - 1
    control_points = (0..len).to_a.map { |i| i * (1.0 / len) }
    from_control_points(control_points.zip(colors))
  end

  def self.from_control_points(control_points)
    # loop palette
    make_looped!(control_points)
    lambda do |index|
      index %= 1
      return [0, 0, 0] if index.class == Float && index.nan?

      (cp_right, color_right), i_right = control_points.each_with_index.find { |(cp, _color), _i| index <= cp }
      cp_left, color_left = control_points[i_right - 1]

      color_left.zip(color_right).map do |l, r|
        interpolate(index, cp_left, l, cp_right, r).round
      end
    end
  end

  private

  def self.interpolate(x, x1, y1, x2, y2)
    y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
  end

  def self.make_looped!(control_points)
    cp_first, color_first = control_points.first
    cp_last, color_last = control_points.last
    control_points.push([1.0 + cp_first, color_first])
    control_points.unshift([-(1.0 - cp_last), color_last])
  end
end

PALETTES = {
  greyscale: FractalMethod.escape_time\
              >> Palette.from_colors([[255, 255, 255], [0, 0, 0], [255, 255, 255]]),
  colorful: FractalMethod.escape_time >> Palette.from_control_points(
    [[0, [0, 7, 100]],
     [0.16,    [32,  107, 203]],
     [0.42,    [237, 255, 255]],
     [0.6425,  [255, 170, 0]],
     [0.8575,  [0,   2,   0]]]
  ),
  colorful_smooth: FractalMethod.smooth >> Palette.from_control_points(
    [[0, [0, 7, 100]],
     [0.00001, [237, 255, 255]],
     [0.0001, [32, 107, 203]],
     [0.00015, [237, 255, 255]],
     [0.0025, [0, 192, 199]],
     [0.005, [0, 7, 100]],
     [1, [0, 2, 0]]]
  ),
  testing: FractalMethod.smooth >> Palette.from_control_points(
    [[0, [0, 7, 100]], [0.005, [32, 107, 203]], [1, [0, 0, 0]]]
  )
}.freeze

FRACTALS = {
  mandelbrot: [[0, :point], ->(z, c) { z**2 + c }],
  burning_ship:
    [[0, :point], ->(z, c) { z.real**2 - z.imaginary**2 - c }],
  julia_1: [[:point, 0.355 + 0.355i], ->(z, c) { z**2 + c }],
  julia_2: [[:point, 0.37 + 0.1i], ->(z, c) { z**2 + c }],
  julia_3: [[:point, -0.54 + 0.54i], ->(z, c) { z**2 + c }],
  sin_z: [[:point, 2], ->(z, c) { c * CMath.sin(z) }],
  cos_z: [[:point, 2], ->(z, c) { c * CMath.cos(z) }]
}.freeze
