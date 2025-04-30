require_relative "header"
require_relative "section_headers"
require_relative "sections"

class Rinker::ELF::Reader
  attr_reader :binary, :file
  attr_reader :elf_header, :section_headers, :sections
  class Error < StandardError; end

  def self.read(file) = new(file).read
   
  def initialize(file)
    @file = file
    @binary = File.open(file, "rb").read
  end
  
  def read
    @elf_header = Rinker::ELF::Header.new(binary[0...0x40])
    shoffset = @elf_header.shoffset
    @section_headers = Rinker::ELF::SectionHeaders.new(binary: binary[shoffset..-1])
    @sections = Rinker::ELF::Sections.new(binary:, section_headers:, elf_header:)
    self
  end

  private
  def b2i(bin)
    case bin.size
    when 1 then bin.unpack("C").first
    when 2 then bin.unpack("S").first
    when 4 then bin.unpack("L").first
    when 8 then bin.unpack("Q").first
    else raise Error, "Unsupported binary size: #{bin.size}"
    end
  end
end
