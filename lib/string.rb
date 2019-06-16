class String
  def hexify
    self.bytes.map { |b| sprintf("%02x", b) }.join
  end

  def unhexify
    self.scan(/../).map { |c| c.hex.chr }.join
  end
end
