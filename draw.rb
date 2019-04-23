require 'oily_png'
require_relative 'mandelbrot'

$X, $Y = 800, 800

$png = ChunkyPNG::Image.new($X, $Y, ChunkyPNG::Color::WHITE)

$colors = (0..19).each do |i|
  ChunkyPNG::Color.from_hsv(i*3, 1, 1)
end.to_a
$mandelbrot = Mandelbrot.new(:black, $colors)

# Use a block to determine color of each pixel
def plot
  verts = (0..$X-1).to_a.product((0..$Y-1).to_a)
  verts.each { |x, y| $png.set_pixel(x, y, yield(x, y)) }
end

def mandelbrot_norm(x, y)
  x = (x - $X / 2.0) * 4.0 / $X
  y = (y - $Y / 2.0) * 4.0 / $Y
  ChunkyPNG::Color($mandelbrot.color_at(x,y))
end

def render
  plot { |x,y| mandelbrot_norm(x, y) }
  $png.save('mandelbrot.png')
end
