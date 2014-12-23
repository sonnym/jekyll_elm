require 'elm_compiler'
require 'pry'

module Jekyll
  class ElmConverter < Converter
    safe false

    def matches(ext)
      ext =~ /^\.elm$/i
    end

    def output_ext(ext)
      '.html'
    end

    def convert(content)
      ElmCompiler.new(content).process!
    end
  end
end
