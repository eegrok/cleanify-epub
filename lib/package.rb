require 'cli'
require 'dohutil/core_ext/string'
require 'fileutils'

module Package
extend self

def unpack_epub(file)
  FileUtils.rm_rf('/tmp/cleanify_dir')
  Cli.execute_cmd("unzip #{file} -d /tmp/cleanify_dir")
end

def add_extension(file, extension)
  return file if extension.empty?
  first = file.rbefore('.epub')
  "#{first}#{extension}.epub"
end

def pack_epub(file, extension)
  Cli.execute_cmd("cd /tmp/cleanify_dir; zip #{file} -r *")
  FileUtils.cp(File.join('/tmp/cleanify_dir', file), add_extension(file, extension))
  FileUtils.rm_rf('/tmp/cleanify_dir')
end

end
