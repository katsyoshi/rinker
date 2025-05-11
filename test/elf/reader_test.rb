require "test_helper"

class Rinker::ELF::ReaderTest < Test::Unit::TestCase
  def setup
    @reader = Rinker::ELF::Reader.new("test/fixtures/plus.o")
    @reader.read
  end

  test "read elf header" do
    elf_header = @reader.elf_header
    assert_equal elf_header.type, "REL"
    assert_equal elf_header.arch, "x64"
    assert_equal elf_header.ident, "\x7FELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    assert_equal elf_header.version, 1
    assert_equal elf_header.entry, 0
    assert_equal elf_header.phoffset, 0
    assert_equal elf_header.shoffset, 288
    assert_equal elf_header.flags, 0
    assert_equal elf_header.ehsize, 64
    assert_equal elf_header.phsize, 0
    assert_equal elf_header.phnum, 0
    assert_equal elf_header.shentsize, 64
    assert_equal elf_header.shnum, 8
    assert_equal elf_header.shstrndx, 7
  end

  test "read section header" do
    headers = @reader.section_headers
    assert_equal headers[0].name, 0
    assert_equal headers[1].name, 27
    assert_equal headers[2].name, 33
    assert_equal headers[3].name, 39
    assert_equal headers[4].name, 44
    assert_equal headers[5].name, 1
    assert_equal headers[6].name, 9
    assert_equal headers[7].name, 17
  end

  test "read shstrtab sections" do
    shstrtab = @reader.sections.shstrtab
    binary = @reader.sections.shstrtab.binary

    assert_equal shstrtab[0], :".null"
    assert_equal binary[0..].split(/\0/).first, ""
    assert_equal shstrtab[1], :".symtab"
    assert_equal shstrtab[2], :".strtab"
    assert_equal shstrtab[3], :".shstrtab"
    assert_equal shstrtab[4], :".text"
    assert_equal binary[27..].split(/\0/).first, ".text"
    assert_equal shstrtab[5], :".data"
    assert_equal shstrtab[6], :".bss"
    assert_equal binary[39..].split(/\0/).first, ".bss"
    assert_equal shstrtab.names[7], :".note.gnu.property"
  end

  test "read symtab section" do
    symbols = @reader.sections.symtab.symbols
    assert_equal symbols.size, 2
    main = symbols.last
    assert_equal main.name, 1
    assert_equal main.info, 16
    assert_equal main.other, 0
    assert_equal main.shndx, 1
    assert_equal main.value, 0
    assert_equal main.size, 0
  end

  test "read bss section" do
    bss = @reader.sections.bss
    assert_equal bss.size, 0
  end

  test "read data section" do
    data = @reader.sections.data
    assert_equal data.size, 0
  end

  test "read text section" do
    text = @reader.sections.text
    assert_equal text.size, 50
  end
end
