require 'rmagick'
include Magick
require_relative 'mandelbrot'

class Plot
  attr_reader :image

  def initialize(color_method)
    @color_method = color_method
  end

  def generate(width, height)
    pixels = []
    (0..height-1).each do |y|
      (0..width-1).each do |x|
        p = Pixel.from_color(@color_method.(x, y))
        pixels.push(p.red)
        pixels.push(p.green)
        pixels.push(p.blue)
      end
    end

    @image = Image.constitute(width, height, "RGB", pixels)
  end
end

def plot_mandelbrot(width, height, iterations)
  p = Plot.new(lambda do |x,y|
    Mandelbrot.color_at(
      *Mandelbrot.normalize_point(x, y, width, height), iterations
    )
  end)
  p.generate(width, height)
  return p
end

if ARGV.length >= 3
  width, height = ARGV[0].to_i, ARGV[1].to_i, 
  iterations = ARGV[2].to_f
  p = plot_mandelbrot(width, height, iterations)
  if ARGV[3]
    p.image.write(ARGV[3])
  else
    p.image.display
  end
else
  puts "Usage: draw.rb width height iterations [filename]"
  puts "If no filename provided will display in imagemagick window."
end
