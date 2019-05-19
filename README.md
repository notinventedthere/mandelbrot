# Mandelbrot Renderer

Renders a Mandelbrot image https://en.wikipedia.org/wiki/Mandelbrot_set.

Other fractals available.

---

Rendered with `ruby draw.rb 1600 1600 -p colorful_smooth -i 200` and downscaled
![Mandelbrot, colorful](https://github.com/notinventedthere/mandelbrot/raw/master/examples/mandel.png)

---

Rendered with `ruby draw.rb 1600 1600 -p greyscale -i 300 -t julia_2` and
downscaled
![Julia fractal #2, greyscale](https://github.com/notinventedthere/mandelbrot/raw/master/examples/julia_2_greyscale.png)

---

Rendered with `ruby draw.rb 1600 1600 -p colorful -i 200 -t julia_2` and
downscaled
![Julia fractal #2, colorful](https://github.com/notinventedthere/mandelbrot/raw/master/examples/julia_2_colorful.png)

---

Rendered with `ruby draw.rb 1600 1600 -p colorful -i 200 -t julia_3` and
downscaled
![Julia fractal #3, colorful](https://github.com/notinventedthere/mandelbrot/raw/master/examples/julia_3_colorful.png)

---

Rendered with `ruby draw.rb 1600 1600 -i 300 -t cos_z` and
downscaled
![Julia fractal using cosine, colorful](https://github.com/notinventedthere/mandelbrot/raw/master/examples/cos_z_colorful.png)


## Installation
Install rmagick with `gem install rmagick`. Requires imagemagick to be installed.

## Usage
`ruby draw.rb width height [options]`

Pass `--help` for options and available fractals
