require 'rmagick'
include Magick
require_relative 'fractal'
require 'optparse'

def plot(width, height)
  pixels = []
  (0..height-1).each do |y|
    (0..width-1).each do |x|
      pixel = Pixel.from_color(yield(x,y))
      pixels.push(pixel.red * 6, pixel.green * 6, pixel.blue * 6)
    end
  end

  Image.constitute(width, height, "RGB", pixels)
end

def scale_point(x, y, width, height, scale)
  x = x * scale / width
  y = y * scale / height
  return x, y
end

$options = {
  iterations: 50,
  fractal: :mandelbrot,
  method: :escape_time,
  palette: :colorful,
  scale: 4.0,
  position: [-2.4, -2.0]
}

OptionParser.new do |opts|
  opts.accept(Symbol) { |string| string.to_sym }
  opts.banner = "Usage: draw.rb width height [$options]"

  opts.on("-i", "--iterations N", Integer,
          "Number of iterations for each pixel. Default: 50") do |n|
    $options[:iterations] = n
  end

  opts.on("-f", "--filename FILENAME",
          "Filename to save image to \
          If none provided will display in window") do |filename|
    $options[:filename] = filename
  end

  opts.on("-t", "--type FRACTAL", Symbol,
          "Type of fractal to draw. Available: " + FRACTALS.keys.join(', ')) do |fractal|
    $options[:fractal] = fractal
  end

  opts.on("-c", "--coloring-method METHOD", Symbol,
          "Which coloring algorithm to use. Available: " + COLORING_METHODS.keys.join(', ')) do |method|
    $options[:method] = method
  end

  opts.on("-p", "--palette COLORS", Symbol,
          "Which color palette to use. Available: " + PALETTES.keys.join(', ')) do |palette|
    $options[:palette] = palette
  end

  opts.on("-s", "--scale N", Float, "Zoom level") do |scale|
    $options[:scale] *= scale
  end

  opts.on("-x N", Float, "x position") { |x| $options[:position][0] += x }
  opts.on("-y N", Float, "y position") { |y| $options[:position][1] += y }

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

def run(width, height, options)
  fractal = Fractal.new(
    *FRACTALS[options[:fractal]],
    COLORING_METHODS[options[:method]],
    PALETTES[options[:palette]]
  )
  plot(width, height) do |x, y|
    x, y = scale_point(x, y, width, height, options[:scale])
    x, y = [x + options[:position].first, y + options[:position].last]
    fractal.color_at(x, y, options[:iterations])
  end
end

if ARGV[0] && ARGV[1]
  width, height = ARGV.take(2).map(&:to_i)
  image = run(width, height, $options)
  if $options[:filename]
    image.write($options[:filename])
  else
    image.display
  end
else
  puts "width and height required"
end
