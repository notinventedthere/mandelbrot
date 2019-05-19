# frozen_string_literal: true

require 'test/unit'
require_relative 'fractal'

class PaletteTests < Test::Unit::TestCase
  def setup
    @colors_1 = [[0, 0, 0], [255, 255, 255], [0, 0, 0]]
    @colors_2 = [[0, 0, 0], [255, 255, 255]]
    @palette_1 = Palette.from_colors(@colors_1)
    @palette_2 = Palette.from_colors(@colors_2)
  end

  def test_original_indices_remain
    assert_equal(@colors_1, [@palette_1.call(0), @palette_1.call(0.5), @palette_1.call(1)])
  end

  def test_interpolate_halfway
    assert_equal(@colors_1[1].map { |c| (c / 2.0).round }, @palette_1.call(0.25))
  end

  def test_mod
    assert_equal(@colors_2[1].map { |c| (c / 2.0).round }, @palette_2.call(1.5))
  end

  def test_looping
    palette = Palette.from_control_points([0, 0.5].zip(@colors_1))
    assert_equal(@colors_2[1].map { |c| (c / 2.0).round }, palette.call(0.75))
  end
end
