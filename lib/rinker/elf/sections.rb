require_relative "section/shstrtab"

class Rinker::ELF::Sections
  attr_reader :binary, :section_headers, :elf_header
  attr_reader :shstrtab, :symtab, :strtab, :data, :text, :bss, :note, :null

  def initialize(binary:, elf_header:, section_headers:)
    @binary, @section_headers, @elf_header = binary, section_headers, elf_header
    parse!
  end

  def parse!
    sh_offset = section_headers[elf_header.shstrndx].offset
    sh_size = section_headers[elf_header.shstrndx].size
    sh_end = sh_offset + sh_size
    @shstrtab = Rinker::ELF::Section::ShStrTab.new(binary: binary[sh_offset..sh_end])
  end
end
