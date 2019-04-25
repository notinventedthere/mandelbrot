require 'benchmark'
require_relative 'mandelbrot'

$mandelbrot = Mandelbrot.new(nil, (0..49).to_a)

Benchmark.bm(1_000_000) do |x|
  x.report('middle:') { $mandelbrot.color_at(0.0,0.0,50) }
  x.report('outer:') { $mandelbrot.color_at(2.0,2.0,50) }
end
