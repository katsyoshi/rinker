require_relative "../section"

class Rinker::ELF::Section::ShStrTab
  attr_reader :binary
  attr_reader :names

  def initialize(binary:)
    @binary = binary
    parse!
  end
        
  def parse! = @names ||= @binary.split("\0").map { (it == "" ? ".null" : it).to_sym }
end
