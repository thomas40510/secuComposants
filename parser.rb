# frozen_string_literal: true

# color codes for terminal output
$blue = "\e[34m"
$red = "\e[31m"
$green = "\e[32m"
$nocolor = "\e[0m"


# class Parser
# This class is used to parse data from folder
# and write it to files
class Parser
  # Initialize parser given the input folder.
  # @param [String] folder
  def initialize(folder)
    @folder = folder
    @ptis = []
    @keys = []
    @ctos = []
    @traces = []
    print("#{$blue} ====== Data parser for electromagnetic traces ====== #{$nocolor}\n")
    print("I will read data from folder: #{@folder}\n")
  end

  # @deprecated
  # Parse data from folder and store it in arrays.
  # @return [Array] @keys, @ptis, @ctos, @traces
  def parse
    # file name format is trace_AES_*_key=*_pti=*_cto=*
    # content is trace
    i = 0
    t0 = Time.now
    Dir.glob("#{@folder}/*").each do |file|
      file_name = File.basename(file)
      @keys << file_name.split('=')[1].split('_')[0]
      @ptis << file_name.split('=')[2].split('_')[0]
      @ctos << file_name.split('=')[3].split('.')[0]
      @traces[i += 1] = File.read(file).split(',').map(&:to_f)
      print("Read #{i} files. Total time: #{Time.now - t0}s\r")
    end
  end

  # Parser.parse_and_write
  # Simultaneously parse and write data from folder to files (fastest method).
  # Specifically, input is folder with files named as 'trace_AES_*_key=*_pti=*_cto=*.csv' containing traces.
  # Output are files named as 'keys.ext', 'ptis.ext', 'ctos.ext', 'traces.ext' the extracted data in 'out/' dir.
  # @param [String] ext extension of output files
  # @option ext [String] txt raw text format
  # @option ext [String] csv comma-separated values format
  def parse_and_write(ext = 'txt')
    i = 0
    t0 = Time.now
    sep = ext == 'txt' ? '\n' : ','
    hexsep = ext == 'txt' ? ' ' : ','
    ext = ".#{ext}" unless ext[0] == '.'
    files = %w[keys ptis ctos traces]

    open_files = files.map do |file|
      dir = 'out/'
      Dir.mkdir(dir) unless Dir.exist?(dir)
      file += ext
      File.delete(dir + file) if File.exist?(dir + file)
      File.open(dir + file, 'w')
    end
    Dir.glob("#{@folder}/*").each do |file|
      file_name = File.basename(file)
      key = file_name.split('=')[1].split('_')[0].scan(/../).map(&:hex).join(hexsep)
      pti = file_name.split('=')[2].split('_')[0].scan(/../).map(&:hex).join(hexsep)
      cto = file_name.split('=')[3].split('.')[0].scan(/../).map(&:hex).join(hexsep)
      open_files[0].puts "#{key}#{sep}"
      open_files[1].puts "#{pti}#{sep}"
      open_files[2].puts "#{cto}#{sep}"
      open_files[3].puts File.read(file).split(',').each_slice(4000).map { |slice| slice.join(sep) }.join(sep)
      print("Read #{i += 1} files. Total time: #{Time.now - t0}s\r")
    end
    # close files
    open_files.each(&:close)
  end

  # @deprecated
  # Parser.write_files
  # Write data to files.
  # Specifically, input is folder with files named as 'trace_AES_*_key=*_pti=*_cto=*.csv' containing traces.
  # Output are files named as 'keys.txt', 'ptis.txt', 'ctos.txt', 'traces.txt' the extracted data in 'out/' dir.
  def write_files
    files = %w[keys.txt ptis.txt ctos.txt traces.txt]
    t0 = Time.now
    files.each do |file|
      dir = 'out/'
      print("Writing file #{file}. Elapsed so far: #{Time.now - t0}s.\n")
      Dir.mkdir(dir) unless Dir.exist?(dir)
      File.open(dir + file, 'w') do |f|
        f.puts instance_variable_get("@#{file.split('.')[0]}")
      end
    end
  end
end


# read input dir and optional extension from command line
input_dir = ARGV[0]
unless input_dir
  print("Please provide input directory. Usage : ruby parser.rb input_dir [output_extension]\n")
  exit
end

ext = ARGV[1] || 'txt'

parser = Parser.new(input_dir)
t0 = Time.now
parser.parse_and_write(ext)
print("\n#{$green}FinEx in #{Time.now - t0}. Files saved in /out directory.#{$nocolor}\n")
