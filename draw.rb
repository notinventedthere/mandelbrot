require 'rmagick'
include Magick
require_relative 'mandelbrot'
require 'optparse'

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

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: draw.rb width height [options]"

  opts.on("-i", "--iterations N", Integer,
          "Number of iterations for each pixel. Default: 50") do |n|
    options[:iterations] = n
  end

  opts.on("-f", "--filename FILENAME",
          "Filename to save image to.\
          If none provided will display in window.") do |filename|
    options[:filename] = filename
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

options[:iterations] ||= 50
if ARGV[0] && ARGV[1]
  width, height = ARGV.take(2).map(&:to_i)
  p = plot_mandelbrot(width, height, options[:iterations])

  if options[:filename]
    p.image.write(options[:filename])
  else
    p.image.display
  end
else
  puts "width and height required"
  exit 1
end
