# frozen_string_literal: true

require_relative "rinker/version"

module Rinker
  class Error < StandardError; end
  class Linker
    def self.link(ofiles, dest: "a.out") = new(ofiles, dest).link

    def initialize(ofiles, dest: "a.out")
      @objects = ofiles
      @dest = dest
      @intermidiates = []
    end

    def link
      @objects.each do |obj|
        name, bin = File.basename(obj), File.read(obj)
      end
    end
  end
end
