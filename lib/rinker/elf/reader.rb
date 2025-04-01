class Array
  def to_hex = (map { |n| n.to_s(16).rjust(2, "0") }.reverse.join)
end

class Rinker::ELF::Reader
  attr_reader :binary, :file
  class Error < StandardError; end

  def self.read(file) = new(file).to_hash
   
  def initialize(file)
    @file = file
    @binary = File.open(file, "rb").read.unpack("C*")
  end

  def to_hash
    {
      header:,
      binary:,
      offset: 0,
      size: header[:size],
      type: type,
      # symbol_table: symbol_table,
      section_table: section_table,
    }
  end

  private
  def type
    case binary[16..17].first
    when 0 then "NONE"
    when 1 then "REL"
    when 2 then "EXEC"
    when 3 then "DYN"
    when 4 then "CORE"
    else "LOPROC"
    end
  end
  def arch
    case ar = binary[18..19].to_hex.to_i(16)
    when 0x3E then "x64"
    else
      raise Error, "Unsupported architecture: #{ar}"
    end
  end
  def header
    @header ||= {
      ident: binary[0..15],
      type:,
      arch:,
      version: binary[20..23].to_hex.to_i(16),
      entry: binary[24..31].to_hex.to_i(16),
      phoffset: binary[32..39].to_hex.to_i(16),
      shoffset: binary[40..47].to_hex.to_i(16),
      flags: binary[48..51].to_hex.to_i(16),
      ehsize: binary[52..53].to_hex.to_i(16),
      phsize: binary[54..55].to_hex.to_i(16),
      phnum:  binary[56..57].to_hex.to_i(16),
      shentsize: binary[58..59].to_hex.to_i(16),
      shnum: binary[60..61].to_hex.to_i(16),
      shstrndx: binary[62..63].to_hex.to_i(16),
    }
  end
  def section_table
    offset = section_header[header[:shstrndx]][:offset]
    size = section_header[header[:shstrndx]][:size]
    section_names = {}
    index = 0
    binary[offset..(offset + size)].pack("C*").split("\0").map do |name|
      section_names[name.to_sym] = index
      index += 1
    end
    section_names
  end

  def section_header
    @section_headers = []
    binary[header[:shoffset]..-1].each_slice(0x40).each_with_index do |bin, i|
      @section_headers << {
        name: bin[0..3].to_hex.to_i(16),
        type: bin[4..7].to_hex.to_i(16),
        flags: bin[8..15].to_hex.to_i(16),
        addr: bin[16..23].to_hex.to_i(16),
        offset: bin[24..31].to_hex.to_i(16),
        size: bin[32..39].to_hex.to_i(16),
        link: bin[40..43].to_hex.to_i(16),
        info: bin[44..47].to_hex.to_i(16),
        addralign: bin[48..55].to_hex.to_i(16),
        entsize: bin[56..63].to_hex.to_i(16),
      }
    end
    @section_headers
  end

end

