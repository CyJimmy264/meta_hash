require 'resolv'

class MetaHash::Net::Base
  attr_reader :net

  def initialize(net)
    @net = net
    @ip_scores = MetaHash::Net::IPScores.load
  end

  def ips
    @ips ||= Resolv::DNS.open do |dns|
      ress = dns.getresources host, Resolv::DNS::Resource::IN::A
      ress.map { |r| r.address.to_s }
    end
  end

  def ip
    ips & ip_scores.keys

    (ips - ip_scores).sample
  end

  def host
    raise NotImplementedError
  end

  def port
    raise NotImplementedError
  end
end
