require 'dohutil/disable_verbose'
Doh.disable_verbose do
  require 'openssl'
end
require 'digest/sha2'
require 'enumerator'

module Crypt
DEFAULT_ENCRYPT_PASS = 'jasildfjlksjdfuwwhe82384#&*$&#*sdfljsd'

def self.hex_encode(string)
  result = ''
  string.each_byte { |byte| result << "%02x" % byte }
  result
end

def self.hex_decode(string)
  result = ''
  string.split('').each_slice(2) {|elem| result << elem.join.hex.chr}
  result
end

# rewritten from encryptor gem
def self.encrypt(string, password = DEFAULT_ENCRYPT_PASS)
  return '' if string == ''
  hex_encode(aes256_encrypt(string, Digest::SHA256.hexdigest(password)))
end

def self.decrypt(string, password = DEFAULT_ENCRYPT_PASS)
  return '' if string == ''
  aes256_decrypt(hex_decode(string), Digest::SHA256.hexdigest(password))
end

protected
def self.aes256_encrypt(string, key)
  aes256_crypt(:encrypt, string, key)
end

def self.aes256_decrypt(string, key)
  aes256_crypt(:decrypt, string, key)
end

def self.aes256_crypt(cipher_method, string, key)
  cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  cipher.send(cipher_method)
  cipher.pkcs5_keyivgen(key)
  result = cipher.update(string)
  result << cipher.final
end

end