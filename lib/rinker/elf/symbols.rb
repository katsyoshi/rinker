require_relative "section/symtab"

class Rinker::ELF::Symbols
  attr_reader :binary
  attr_reader :symbols
  def initialize(binary:)
    @binary = binary
    parse!
  end

  def parse(bin)
    symbols = []
    b = StringIO.new(@binary)
    while bstr = b.read(24)
      symbols << Rinker::ELF::Section::SymTab.new(binary: bstr)
    end
    symbols
  end

  def parse! = @symbols ||= parse(@binary)
  def [](index) = @symbols[index]
  def each(&block) = @symbols.each(&block)
end
