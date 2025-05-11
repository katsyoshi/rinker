require_relative "../section"

class Rinker::ELF::Section::Data
  attr_reader :binary
  def initialize(binary:) = @binary = binary
  def size = @binary.bytesize
end
