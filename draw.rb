require 'rmagick'
include Magick
require_relative 'mandelbrot'

$WIDTH, $HEIGHT = 800, 800
$MAX = 50.0

$image = Image.new($WIDTH, $HEIGHT) { self.background_color = "red" }

$colors = (0..$MAX).to_a.reverse.map { |i| "hsl(#{235 / $MAX * i}, 200, 100)" }
$mandelbrot = Mandelbrot.new("black", $colors)

# Use a block to determine color of each pixel
def plot
  verts = (0..$WIDTH-1).to_a.product((0..$HEIGHT-1).to_a)
  verts.each { |x, y| $image.pixel_color(x, y, yield(x, y)) }
end

def norm(x, y)
  x = (x - $WIDTH / 2.0) * 4.0 / $WIDTH
  y = (y - $HEIGHT / 2.0) * 4.0 / $HEIGHT
  return x, y
end

def render
  plot { |x,y| $mandelbrot.color_at(*norm(x, y), $MAX) }
  $image.display
end

render
