require 'rmagick'
include Magick
require_relative 'fractal'
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
        pixels.push(p.red, p.green, p.blue)
      end
    end

    @image = Image.constitute(width, height, "RGB", pixels)
  end
end

def scale_point(x, y, width, height, scale)
  x = x * scale / width
  y = y * scale / height
  return x, y
end

options = {
  iterations: 50,
  fractal: :mandelbrot,
  scale: 4.0,
  position: [-2.4, -2.0]
}

OptionParser.new do |opts|
  opts.accept(Symbol) { |string| string.to_sym }
  opts.banner = "Usage: draw.rb width height [options]"

  opts.on("-i", "--iterations N", Integer,
          "Number of iterations for each pixel. Default: 50") do |n|
    options[:iterations] = n
  end

  opts.on("-f", "--filename FILENAME",
          "Filename to save image to \
          If none provided will display in window") do |filename|
    options[:filename] = filename
  end

  opts.on("-t", "--type FRACTAL", Symbol,
          "Type of fractal to draw. Available: " + FRACTALS.keys.join(', ')) do |fractal|
    options[:fractal] = fractal
  end

  opts.on("-s", "--scale N", Float, "Zoom level") do |scale|
    options[:scale] *= scale
  end

  opts.on("-x N", Float, "x position") { |x| options[:position][0] += x }
  opts.on("-y N", Float, "y position") { |y| options[:position][1]  += y }

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

if ARGV[0] && ARGV[1]
  width, height = ARGV.take(2).map(&:to_i)
  p = Plot.new(
    -> (x, y) do
      x, y = scale_point(x, y, width, height, options[:scale])
      x, y = [x + options[:position].first, y + options[:position].last]
      FRACTALS[options[:fractal]].color_at(x, y, options[:iterations])
    end
  )
  p.generate(width, height)

  if options[:filename]
    p.image.write(options[:filename])
  else
    p.image.display
  end
else
  puts "width and height required"
  exit 1
end
