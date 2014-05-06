require 'open3'
require 'securerandom'

class ElmCompiler
  def initialize(content)
    setup_dir

    @content = content
  end

  def process!
    output = '', status = nil

    with_error_handling do
      File.open(tmp_path, 'w') { |f| f.write(@content) }

      in_elm_dir do
        out, err, status = Open3.capture3("elm --make --runtime=/javascripts/elm-runtime.js #{tmp_file}.elm")

        unless status.success?
          puts '*** ERROR: Elm'
          puts "** OUT:\n#{out}"
          puts "** ERR:\n#{err}"
        end
      end

      output = File.read(File.join(elm_dir, 'build', "#{tmp_file}.html")) if status.success?
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
    File.join(elm_dir, "#{tmp_file}.elm")
  end
end
