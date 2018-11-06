require 'open3'
require 'securerandom'

class ElmCompiler
  ELM_COMMAND = 'PATH=$(yarn bin):$PATH elm make'

  def initialize(content)
    setup_dir

    @content = content
  end

  def process!
    output = '', status = nil

    with_error_handling do
      result = File.open(tmp_path, 'w') { |f| f.write(@content) }

      out, err, status = Open3.capture3("#{ELM_COMMAND} #{tmp_path} --output #{dest_path}")

      if status.success?
        output = File.read(dest_path)
        File.delete(dest_path)
      else
        puts '*** ERROR: Elm'
        puts "** OUT:\n#{out}"
        puts "** ERR:\n#{err}"
      end
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
      puts "*** ERROR Elm: #{e.inspect}"
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

  def dest_path
    File.join(elm_dir, 'build', "#{tmp_file}.html")
  end
end
