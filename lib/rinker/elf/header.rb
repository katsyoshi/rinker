class Rinker::ELF::Header
  attr_reader :binary
  attr_reader :ident, :version, :entry, :phoffset, :shoffset, :flags, :ehsize, :phsize, :phnum, :shentsize, :shnum, :shstrndx
  class Error < StandardError; end

  def initialize(bin)
    @binary = bin
    parse!
  end

  def parse!
    @ident = @binary[0..15]
    @version, @entry, @phoffset, @shoffset, @flags, @ehsize, @phsize, @phnum, @shentsize, @shnum, @shstrndx = @binary[20..63].unpack("LQ3LS6")
  end

  def type
    @type ||= case @binary[16..17].unpack("S").first
              when 0 then "NONE"
              when 1 then "REL"
              when 2 then "EXEC"
              when 3 then "DYN"
              when 4 then "CORE"
              else "LOPROC"
              end
  end
  def arch
    @arch ||= case @binary[18..19].unpack("S").first
              when 0x3E then "x64"
              else raise Error, "Unsupported architecture: #{@binary[18..19].unpack}"
              end
  end
end
