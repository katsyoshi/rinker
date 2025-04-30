class Rinker::ELF::Section::SymbolTable
  attr_reader :binary
  attr_reader :symbols
        
  def initialize(bin)
    @binary = bin
    @symbols = []
  end
        
  def parse!
    binary.split("\0").each do |symbol|
      name = symbol == "" ? ".null" : symbol
      @symbols << name.to_sym
    end
  end
        
  def [](index) = symbols[index]
  def each(&block) = symbols.each(&block)
end
