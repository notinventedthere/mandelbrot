require 'rmagick'
include Magick
require_relative 'mandelbrot'

$WIDTH, $HEIGHT = 3200, 3200
$MAX = 200.0

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
  x = (x - $WIDTH / 2.0) * 4.0 / $WIDTH
  y = (y - $HEIGHT / 2.0) * 4.0 / $HEIGHT
  return x, y
end

def render
  $image = generate($WIDTH, $HEIGHT) do |x,y|
    Mandelbrot.color_at(*norm(x, y), $MAX)
  end
  $image.display
end
