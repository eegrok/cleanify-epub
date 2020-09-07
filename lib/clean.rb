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
      replacement = value.sample.dup
      multiple_choice = true
    else
      replacement = value.dup
    end
    begin
      line =~ word
      orig_phrase = $2
      if orig_phrase
        if orig_phrase[0] =~ /[[:upper:]]/
          replacement[0] = replacement[0].upcase
        end
        puts "original phrase being replaced is: #{orig_phrase}" if Doh.config[:verbose]
        line.gsub!(word, '\1' + replacement + '\3')
      end
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

def clean_epub(dir = '/tmp/cleanify_dir')
  Dir.glob(File.join(dir, '/**/*.html')).each do |file|
    if !File.directory?(file)
      puts "processing file: #{file}" if Doh.config[:debug]
      clean_file(file)
    end
  end
end


end
