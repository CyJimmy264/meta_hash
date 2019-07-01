require 'csv'
require 'filelock'

class MetaHash::Net::IPScores
  def initialize(ips = [])
    case ips
    when Array
      @rating = ips.map { [@1, 0] }.to_h
    when Hash
      @rating = ips
    end
  end

  def self.load(filename)
    scores = CSV.read filename, converters: :numeric

    self.new scores.select(&:any?).to_h
  end

  def rating
    @rating.sort_by { |k,v| -v }.to_h
  end

  def up(ip)
    @rating[ip] += 1
  end

  def down(ip)
    @rating[ip] -= 1
  end

  def save(filename)
    Filelock filename do |file|
      CSV.open filename, 'w' do |csv|
        rating.each { csv << [@1, @2] }
      end
    end
  end
end
