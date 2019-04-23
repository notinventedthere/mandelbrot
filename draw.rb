require 'rmagick'
include Magick
require_relative 'mandelbrot'

$WIDTH, $HEIGHT = 800, 800

$image = Image.new($WIDTH, $HEIGHT) { self.background_color = "red" }

$colors = (0..19).to_a.map { |i| "hsl(#{i*3}, 100, 50)" }
$mandelbrot = Mandelbrot.new("black", $colors)

# Use a block to determine color of each pixel
def plot
  verts = (0..$WIDTH-1).to_a.product((0..$HEIGHT-1).to_a)
  verts.each { |x, y| $image.pixel_color(x, y, yield(x, y)) }
end

def mandelbrot_norm(x, y)
  x = (x - $WIDTH / 2.0) * 4.0 / $WIDTH
  y = (y - $HEIGHT / 2.0) * 4.0 / $HEIGHT
  $mandelbrot.color_at(x,y)
end

def render
  plot { |x,y| mandelbrot_norm(x, y) }
  $image.display
end
