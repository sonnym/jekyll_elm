require 'elm_compiler'

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
      if content =~ /#{@config['excerpt_separator']}$/
        content
      else
        ElmCompiler.new(content).process!
      end
    end
  end
end
