require 'mapping'
require 'crypt'

module Clean
extend self

@@subcount = Hash.new(0)

def clean_line(line)
  orig = line.dup
  multiple_choice = false
  Mapping.get_mappings.each do |word, value|
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
        if Doh.config[:mark_replacements]
          line.gsub!(word, '\1***' + replacement + '\3')
        else
          line.gsub!(word, '\1' + replacement + '\3')
        end
      end
    rescue StandardError => excpt
      puts "got exception: #{excpt.inspect} on line: #{line.inspect}"
      exit 1
    end
  end
  if orig != line
    if Doh.config[:debug]
      if multiple_choice || Doh.config[:verbose]
        if Doh.config[:show_orig]
          puts "orig: #{orig}"
        end
        puts "repl: #{line}"
      end
    end
  end
  line
end

def count_file(file)
  lines = File.readlines(file)
  all_phrases = Mapping.get_substring_phrases.collect {|phrase, regex| phrase}
  lines.each do |line|
    Mapping.get_substring_phrases.each do |phrase, regex|
      found = line.scan(regex).flatten
      found.each do |word|
        whitelisted = false
        Mapping::WHITELIST.each do |whitelist|
          if word =~ /#{whitelist}/i
            whitelisted = true
            break
          end
        end
        if !whitelisted && !all_phrases.include?(word)
          @@subcount[word] += 1
        end
      end
    end
  end
end

def clean_file(file)
  lines = File.readlines(file)
  file = File.open(file, 'w+')
  lines.each do |line|
    file << clean_line(line)
  end
end

def clean_epub(dir = '/tmp/cleanify_dir')
  html = Dir.glob(File.join(dir, '/**/*.html'))
  xhtml = Dir.glob(File.join(dir, '/**/*.xhtml'))
  all = html + xhtml
  all.each do |file|
    if !File.directory?(file)
      puts "processing file: #{file}" if Doh.config[:debug]
      if Doh.config[:count]
        count_file(file)
      else
        clean_file(file)
      end
    end
  end
  if Doh.config[:count]
    @@subcount.keys.each do |key|
      puts "#{key}: #{@@subcount[key]} times"
    end
  end
end


end
