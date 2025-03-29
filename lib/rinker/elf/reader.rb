class Rinker::ELF::Reader
  def self.read(file:) = new(file: file).read
   
  def initialize(file:)
    @file = file
    @binary = File.open(file, "rb").read.unpack("C*")
  end

  def read = **read_header(file).merge(binary: @binary)

  private
  def read_header = {
    ident: @binary[0..15],
    type: @binary[16..17],
    arch: @binary[18..19],
    version: @binary[20..23],
    entry: @binary[24..31],
    phoffset: @binary[32..39],
    shoffset: @binary[40..47],
    flags: @binary[48..51],
    ehsize: @binary[52..53],
    phsize: @binary[54..55],
    phnum: @binary[56..57],
    shentsize: @binary[58..59],
    shnum: @binary[60..61],
    shstrndx: @binary[62..63],
  }
end
