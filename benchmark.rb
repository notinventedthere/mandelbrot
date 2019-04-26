require 'benchmark'
require_relative 'mandelbrot'
require_relative 'draw'

# Mandelbrot
Benchmark.bm(1_000_000) do |x|
  x.report('middle:') { $MANDELBROT.color_at(0.0,0.0,50) }
  x.report('outer:') { $MANDELBROT.color_at(2.0,2.0,50) }
end

verts = (0..$WIDTH-1).to_a.product((0..$HEIGHT-1).to_a)
Benchmark.bm($WIDTH*$HEIGHT) do |z|
  x, y = verts.pop
  z.report('just mandel:') { $MANDELBROT.color_at(*norm(x, y), $MAX) }
end

# Draw
Benchmark.bm(1) do |x|
  x.report('draw without mandel 1:') { plot($image) { 'black' } }
  x.report('draw without mandel 2:') { plot($image) { "hsl(#{235 / $MAX }, 200, 100)" } }
  x.report('draw with mandel:') { plot($image) { |x,y| $MANDELBROT.color_at(*norm(x, y), $MAX) } }
end
