require_relative "../section"

class Rinker::ELF::Section::BSS
  attr_reader :binary
  def initialize(binary:) = @binary = binary
end
