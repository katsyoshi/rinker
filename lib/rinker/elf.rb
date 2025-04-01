class Rinker::ELF
  def initialize(files, output: "a.out")
    @output = output
    @files = files.map do |file|
      elf = Rinker::ELF::Reader.new(file)
      elf.read
      { file: file, elf: elf.to_hash }
    end
  end
end
