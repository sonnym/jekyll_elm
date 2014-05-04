require 'open3'
require 'securerandom'

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
      return content if content =~ /#{@config['excerpt_separator']}$/

      output = nil

      setup_dir

      with_error_handling do
        File.open(tmp_path, 'w') { |f| f.write(content) }

        in_elm_dir do
          _, err = Open3.capture3("elm --make --runtime=/javascripts/elm-runtime.js #{tmp_file}.elm")
          puts "** ERROR: Elm:\n#{err}\n" if err.length > 0
        end

        output = File.read(File.join(elm_dir, 'build', "#{tmp_file}.html"))
      end

      output
    end

    private

    def setup_dir
      Dir.mkdir(elm_dir) unless File.exist?(elm_dir) && File.directory?(elm_dir)
    end

    def with_error_handling
      begin
        yield
      rescue Errno::ENOENT => e
        puts e
        puts "** ERROR: elm isn't installed or could not be found."
        puts "** ERROR: To install with cabal run: cabal install elm"
      ensure
        File.delete(tmp_path)
      end
    end

    def in_elm_dir
      Dir.chdir(elm_dir)
      yield
      Dir.chdir('..')
    end

    def elm_dir
      '_elm'
    end

    def tmp_file
      @tmp_file ||= SecureRandom.hex(16)
    end

    def tmp_path
      @tmp_path ||= File.join(elm_dir, "#{tmp_file}.elm")
    end
  end
end
