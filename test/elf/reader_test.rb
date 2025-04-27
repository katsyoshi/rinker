require "test_helper"

class Rinker::ELF::ReaderTest < Test::Unit::TestCase
  def setup = @reader = Rinker::ELF::Reader.new("test/fixtures/plus.o").to_hash

  test "read elf header" do
    assert_equal @reader[:header][:type], "REL"
    assert_equal @reader[:header][:arch], "x64"
    assert_equal @reader[:header][:ident], "\x7FELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    assert_equal @reader[:header][:version], 1
    assert_equal @reader[:header][:entry], 0
    assert_equal @reader[:header][:phoffset], 0
    assert_equal @reader[:header][:shoffset], 288
    assert_equal @reader[:header][:flags], 0
    assert_equal @reader[:header][:ehsize], 64
    assert_equal @reader[:header][:phsize], 0
    assert_equal @reader[:header][:phnum], 0
    assert_equal @reader[:header][:shentsize], 64
    assert_equal @reader[:header][:shnum], 8
    assert_equal @reader[:header][:shstrndx], 7
  end

  end
end
