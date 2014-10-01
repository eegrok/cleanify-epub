require 'open3'

module Cli
extend self

def error_out(msg, body = '')
  dohlog.error(msg)
  puts "failing out: #{msg}"
  exit 1
end

def execute_cmd(cmd)
  dohlog.debug("executing: #{cmd.inspect}")
  stdout, stderr, status = Open3.capture3(cmd)
  if !status.success?
    error_out("command failed", "cmd: #{cmd.inspect}\nexitstatus: #{status.exitstatus}\nstderr: #{stderr}\nstdout: #{stdout}")
  end
  stdout
end

end
