require 'test/unit'
require_relative 'fractal'

class PaletteTests < Test::Unit::TestCase
  def setup
    @colors = [[0,0,0],[255,255,255],[0,0,0]]
    @palette = Palette.from_colors(@colors)
  end

  def test_original_indices_remain
    assert_equal(@colors, [@palette.(0), @palette.(0.5), @palette.(1)])
  end

  def test_interpolate_halfway
    assert_equal(@colors[1].map { |c| (c / 2.0).round }, @palette.(0.25))
  end
end
