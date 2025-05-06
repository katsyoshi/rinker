require_relative "../section"
class Rinker::ELF::Section::SymTab
  attr_reader :binary
  attr_reader :name, :info, :other, :shndx, :value, :size
        
  def initialize(binary:)
    @binary = binary
    parse!
  end
        
  def parse! = (@name, @info, @other, @shndx, @value, @size = parse(@binary))
  def parse(bin) = bin.unpack("LC2SQ2")
end
