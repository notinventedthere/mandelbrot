require 'benchmark'
require_relative 'mandelbrot'
require_relative 'draw'

$WIDTH, $HEIGHT = 800, 800
$MAX = 50.0
p = Plot.new(800,800)

# Mandelbrot
Benchmark.bm(1_000_000) do |x|
  x.report('middle:') { Mandelbrot.color_at(0.0,0.0,50) }
  x.report('outer:') { Mandelbrot.color_at(2.0,2.0,50) }
end

verts = (0..$WIDTH-1).to_a.product((0..$HEIGHT-1).to_a)
Benchmark.bm($WIDTH*$HEIGHT) do |z|
  x, y = verts.pop
  z.report('just mandel:') { Mandelbrot.color_at(*p.norm(x, y), $MAX) }
end

# Draw
Benchmark.bm(1) do |x|
  x.report('draw without mandel 1:') { p.generate { 'black' } }
  x.report('draw without mandel 2:') { p.generate { "hsl(#{235 / $MAX }, 200, 100)" } }
  x.report('draw with mandel:') { p.generate { |x,y| Mandelbrot.color_at(*p.norm(x, y), $MAX) } }
end
