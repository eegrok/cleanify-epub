require 'mapping'
require 'crypt'

module Clean
extend self


def clean_line(line)
  orig = line.dup
  multiple_choice = false
  Mapping.get_mappings.each do |word, value|
    dohlog.debug("word = #{word.inspect}")
    if value.is_a?(Array)
      replacement = value.sample
      multiple_choice = true
    else
      replacement = value
    end
    begin
      line.gsub!(word, '\1' + replacement + '\3')
    rescue StandardError => excpt
      puts "got exception: #{excpt.inspect} on line: #{line.inspect}"
      exit 1
    end
  end
  if orig != line
    if Doh.config[:debug]
      if multiple_choice || Doh.config[:verbose]
        if Doh.config[:profanities]
          puts "orig: #{orig}"
        end
        puts "repl: #{line}"
      end
    end
  end
  line
end

def clean_file(file)
  lines = File.readlines(file)
  file = File.open(file, 'w+')
  lines.each do |line|
    file << clean_line(line)
  end
end

def clean_epub
  Dir.glob("/tmp/cleanify_dir/**/*.html").each do |file|
    if !File.directory?(file)
      puts "processing file: #{file}" if Doh.config[:debug]
      clean_file(file)
    end
  end
end


end