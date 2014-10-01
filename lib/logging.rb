require 'dohlog'
acceptor = DohLog::StreamAcceptor.new(File.new('cleanify.log', 'w+'))
DohLog::setup(acceptor)
