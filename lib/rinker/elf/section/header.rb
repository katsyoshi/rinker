require_relative "../section"

class Rinker::ELF::Section::Header
  attr_reader :binary
  attr_reader :name, :type, :flags, :addr, :offset, :size, :link, :info, :addralign, :entsize

  def initialize(binary:)
    @binary = binary
    parse!
  end

  def parse! = (@name, @type, @flags, @addr, @offset, @size, @link, @info, @addralign, @entsize = parse(@binary))
  def parse(bin) = bin.unpack("L2Q4L2Q2")
  def [](index) = binary[index]
  def each(&block) = binary.each_byte(&block)
end
