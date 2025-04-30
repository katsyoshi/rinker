require "stringio"
require_relative "section/header"

class Rinker::ELF::SectionHeaders
  attr_reader :binary
  attr_reader :sections
  class Error < StandardError; end

  def initialize(binary:)
    @binary = binary
    @sections = []
    parse!
  end

  def parse!
    bio = StringIO.new(binary)
    while bin = bio.read(0x40)
      sections << Rinker::ELF::Section::Header.new(binary: bin)
    end
    self
  end

  def [](index) = sections[index]
  def each(&block) = sections.each(&block)
end
