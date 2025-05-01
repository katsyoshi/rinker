require_relative "../section"

class Rinker::ELF::Section::Header
  attr_reader :binary
  attr_reader :name, :type, :flags, :addr, :offset, :size, :link, :info, :addralign, :entsize

  def initialize(binary:)
    @binary = binary
    parse!
  end

  def parse! = (@name, @type, @flags, @addr, @offset, @size, @link, @info, @addralign, @entsize = binary.unpack("L2Q4L2Q2"))
end
