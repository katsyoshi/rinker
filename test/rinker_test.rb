# frozen_string_literal: true

require "test_helper"

class RinkerTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Rinker.const_defined?(:VERSION)
    end
  end
end
