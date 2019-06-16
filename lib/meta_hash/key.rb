require 'openssl'

module MetaHash
  class Key
    attr_reader :pkey

    def initialize(pkey)
      @pkey = pkey
    end

    def self.generate
      pkey = OpenSSL::PKey::EC.new("secp256k1")
      pkey.generate_key

      Key.new pkey
    end

    def self.read(filename, passphrase = nil)
      Key.new OpenSSL::PKey.read(File.read(filename), passphrase)
    end

    def self.from_der(str)
      Key.new OpenSSL::PKey.read(str)
    end

    def write(filename, passphrase = nil)
      cipher = OpenSSL::Cipher.new 'AES-128-CBC'
      key_secure = pkey.export cipher, passphrase
      File.write(filename, key_secure)
    end

    def addr
      return @addr if defined? @addr

      pub_last65 = pkey.public_key.to_der.bytes.last(65).map(&:chr).join
      result_sha256 = Digest::SHA256.digest pub_last65
      result_rmd160 = "\x0" + Digest::RMD160.digest(result_sha256)
      result_rmd160sha256 = Digest::SHA256.digest result_rmd160
      result_rmd160sha256sha256 = Digest::SHA256.digest result_rmd160sha256

      @addr = '0x' + result_rmd160.hexify +
              result_rmd160sha256sha256.bytes.first(4).pack('C*').hexify
    end

    def pub(form = :hex)
      @pub ||= pkey.public_key.to_der
      form == :hex ? @pub.hexify : @pub
    end

    def priv(form = :hex)
      @priv ||= pkey.to_der
      form == :hex ? @priv.hexify : @priv
    end

    def sign(data)
      digest = OpenSSL::Digest::SHA256.new
      pkey.sign(digest, data)
    end

    def verify(data, sign)
      digest = OpenSSL::Digest::SHA256.new
      pkey.public_key.verify(digest, sign, data)
    end

  end

  module QuackLikeAPKey
    def to_pem; public_key.to_pem end
    def to_der; public_key.to_der end
    def verify(digest, data, sign); public_key.verify digest, data, sign end
    private
    def public_key
      key = OpenSSL::PKey::EC.new group
      key.public_key = self
      key
    end
  end
  OpenSSL::PKey::EC::Point.prepend QuackLikeAPKey
end

