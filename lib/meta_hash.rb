require 'meta_hash/version'
require 'meta_hash/key'
require 'meta_hash/net'
require 'meta_hash/net/ip_scores'
require 'string'

module MetaHash
  class Error < StandardError; end

  def self.config
    @config ||= OpenStruct.new
  end

  def self.configure
    yield(config)
  end
end
