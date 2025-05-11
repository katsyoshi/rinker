require_relative "../section"

class Rinker::ELF::Section::StrTab
  attr_reader :binary
  attr_reader :names

  def initialize(binary:)
    @binary = binary
    parse!
  end

  def parse! = @names ||= @binary.split("\0").filter_map { it.to_sym if it != "" }
  def size = @names.size
  def [](index) = names[index]
  def each(&block) = names.each(&block)
end
