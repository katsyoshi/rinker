require_relative "section/bss"
require_relative "section/data"
require_relative "section/shstrtab"
require_relative "section/strtab"
require_relative "section/text"
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
      chunk = binary[offset...end_offset]

      case name
      when :".null" then @null = Rinker::ELF::Section::Null.new(binary: chunk)
      when :".symtab" then @symtab = Rinker::ELF::Symbols.new(binary: chunk)
      when :".bss" then @bss = Rinker::ELF::Section::BSS.new(binary: chunk)
      when :".data" then @data = Rinker::ELF::Section::Data.new(binary: chunk)
      when :".text" then @text = Rinker::ELF::Section::Text.new(binary: chunk)
      end
    end
  end
end
