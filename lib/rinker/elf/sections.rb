require_relative "section/shstrtab"
require_relative "symbols"

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
    @shstrtab = Rinker::ELF::Section::ShStrTab.new(binary: binary[sh_offset...sh_end])

    @section_headers.each do |header|
      name = @shstrtab.binary[header.name..].split(/\0/).first.to_sym
      offset = header.offset
      size = header.size
      end_offset = offset + size

      case name
      when :".null" then @null = Rinker::ELF::Section::Null.new(binary: binary[offset...end_offset])
      when :".symtab" then @symtab = Rinker::ELF::Symbols.new(binary: binary[offset...end_offset])
      end
    end
  end
end
