require "stringio"

class Rinker::ELF::Reader
  attr_reader :binary, :file
  class Error < StandardError; end

  def self.read(file) = new(file).to_hash
   
  def initialize(file)
    @file = file
    @binary = File.open(file, "rb").read
  end

  def to_hash
    {
      header:,
      binary:,
      offset: 0,
      size: header[:size],
      type: type,
      section_table: shstrtab,
    }
  end

  private
  def type
    case b2i(binary[16..17])
    when 0 then "NONE"
    when 1 then "REL"
    when 2 then "EXEC"
    when 3 then "DYN"
    when 4 then "CORE"
    else "LOPROC"
    end
  end
  def arch
    case ar = b2i(binary[18..19])
    when 0x3E then "x64"
    else raise Error, "Unsupported architecture: #{ar}"
    end
  end
  def header
    return @header unless @header.nil?
    ident = binary[0..15]
    version, entry, phoffset, shoffset, flags, ehsize, phsize, phnum, shentsize, shnum, shstrndx = binary[20..63].unpack("LQ3LS6")
    @header = { ident:, type:, arch:, version:, entry:, phoffset:, shoffset:, flags:, ehsize:, phsize:, phnum:, shentsize:, shnum:, shstrndx: }
  end

  def shstrtab
    offset = section_headers[header[:shstrndx]][:offset]
    size = section_headers[header[:shstrndx]][:size]
    section_names = {}
    index = 0
    binary[offset..(offset + size)].split("\0").map do |name|
      name = ".null" if name == ""
      section_names[name.to_sym] = index
      index += 1
    end
    section_names
  end

  def symtab
    offset = section_headers[shstrtab[:".symtab"]][:offset]
    size = section_headers[shstrtab[:".symtab"]][:size]
    binary[offset..(offset + size)]
  end

  def section_headers
    return @section_headers unless @section_headers.nil?
    @section_headers = []
    b = StringIO.new(binary[header[:shoffset]..])
    while bin = b.read(0x40)
      name, type, flags, addr, offset, size, link, info, addralign, entsize = bin.unpack("L2Q4L2Q4")
      @section_headers << { name: [name].pack("L"), type:, flags:, addr:, offset:, size:, link:, info:, addralign:, entsize: }
    end
    @section_headers
  end

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
