# Mandelbrot Renderer

Renders a Mandelbrot image https://en.wikipedia.org/wiki/Mandelbrot_set.

Other fractals available.

![rendered with 50 iterations](https://github.com/notinventedthere/mandelbrot/raw/master/mandel.png
"Rendered with 50 iterations")

Example above rendered with `ruby draw.rb 800 800 -i 50`

## TODO
- more detailed coloring
- optimize

## Installation
Install rmagick with `gem install rmagick`. Requires imagemagick to be installed.

## Usage
`ruby draw.rb width height [options]`

Pass `--help` for options and available fractals
