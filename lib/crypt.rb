require 'dohutil/disable_verbose'
Doh.disable_verbose do
  require 'openssl'
end
require 'digest/sha2'
require 'enumerator'

module Crypt
extend self

DEFAULT_ENCRYPT_PASS = 'jasildfjlksjdfuwwhe82384#&*$&#*sdfljsd'

def hex_encode(string)
  result = ''
  string.each_byte { |byte| result << "%02x" % byte }
  result
end

def hex_decode(string)
  result = ''
  string.split('').each_slice(2) {|elem| result << elem.join.hex.chr}
  result
end

# rewritten from encryptor gem
def encrypt(string, password = DEFAULT_ENCRYPT_PASS)
  return '' if string == ''
  hex_encode(aes256_encrypt(string, Digest::SHA256.hexdigest(password)))
end

def decrypt(string, password = DEFAULT_ENCRYPT_PASS)
  return '' if string == ''
  aes256_decrypt(hex_decode(string), Digest::SHA256.hexdigest(password))
end

protected
def aes256_encrypt(string, key)
  aes256_crypt(:encrypt, string, key)
end

def aes256_decrypt(string, key)
  aes256_crypt(:decrypt, string, key)
end

def aes256_crypt(cipher_method, string, key)
  cipher = OpenSSL::Cipher.new('aes-256-cbc')
  cipher.send(cipher_method)
  cipher.pkcs5_keyivgen(key)
  result = cipher.update(string)
  result << cipher.final
end

end
