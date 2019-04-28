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
  def generate
    arr = []
    (0..@height-1).each do |y|
      (0..@width-1).each do |x|
        p = Pixel.from_color(yield(x, y))
        arr.push(p.red)
        arr.push(p.green)
        arr.push(p.blue)
      end
    end
    arr
  end

  def norm(x, y)
    x = (x - @width / 2.0) * 4.0 / @width
    y = (y - @height / 2.0) * 4.0 / @height
    return x, y
  end

  def render(arr)
    @image = Image.constitute(@width, @height, "RGB", arr)
  end
end

unless ARGV.empty?
  p = Plot.new(ARGV[0].to_i, ARGV[1].to_i)
  p.render(p.generate do |x,y|
    Mandelbrot.color_at(*p.norm(x, y), ARGV[2].to_f)
  end)
  p.image.display
end
