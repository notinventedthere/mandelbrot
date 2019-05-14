# Mandelbrot Renderer

Now with other fractals.

![rendered with 50 iterations](https://github.com/notinventedthere/mandelbrot/raw/master/mandel.png
"Rendered with 50 iterations")

Example above rendered with `ruby draw.rb 800 800 -i 50`

## Installation
Install rmagick with `gem install rmagick`. Requires imagemagick to be installed.

## Usage
`ruby draw.rb width height [options]`

Pass `--help` for options

Available fractals for -t option: mandelbrot, burning_ship, sin_z
