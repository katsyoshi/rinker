require_relative "../section"

class Rinker::ELF::Section::Text
  attr_reader :binary
  attr_reader :text
  def initialize(binary:) = @binary = binary
  def parse! = @text ||= parse(@binary)
  def parse(bin) = bin.unpack("C*")
  def [](index) = @text[index]
  def size = @binary.bytesize
  def each(&block) = @binary.each_byte(&block)
end
