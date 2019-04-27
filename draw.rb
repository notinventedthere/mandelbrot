require 'rmagick'
include Magick
require_relative 'mandelbrot'

class Plot
  attr_reader :image

  def initialize(width, height)
    @width = width
    @height = height
  end

  # Use a block to determine color of each pixel
  def generate(width, height)
    arr = []
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        p = Pixel.from_color(yield(x, y))
        arr.push(p.red)
        arr.push(p.green)
        arr.push(p.blue)
      end
    end
    Image.constitute(width, height, "RGB", arr)
  end

  def norm(x, y)
    x = (x - @width / 2.0) * 4.0 / @width
    y = (y - @height / 2.0) * 4.0 / @height
    return x, y
  end

  def render(max)
    @image = generate(@width, @height) do |x,y|
      Mandelbrot.color_at(*norm(x, y), max)
    end
    @image.display
  end
end

Plot.new(ARGV[0].to_i, ARGV[1].to_i).render(ARGV[2].to_f) unless ARGV.empty?
