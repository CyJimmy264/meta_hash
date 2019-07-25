RSpec.describe MetaHash::Net::IPScores do
  let :ip_scores_hash do
    {
      '1.1.1.1' => 0,
      '2.2.2.2' => 1,
      '3.3.3.3' => -1,
    }
  end

  let :ip_scores_hash2 do
    {
      '1.1.1.1' => 3,
    }
  end

  let :ip_scores_rating do
    {
      '2.2.2.2' => 1,
      '1.1.1.1' => 0,
      '3.3.3.3' => -1,
    }
  end

  let :ip_scores_filename do
    'spec/fixtures/ip_scores/example.csv'
  end

  let(:ip_scores) { described_class.new ip_scores_hash }
  let(:ip_scores2) { described_class.new ip_scores_hash2}
  let(:ip) { '2.2.2.2' }

  describe '.new' do
    context 'with no argument given' do
      let(:subject) { described_class.new }

      it 'creates an empty rating list' do
        expect(subject.rating).to be_empty
      end
    end

    context 'with an array of IPs given' do
      let(:subject) { described_class.new ip_scores_hash.keys }

      it 'creates a rating with zero scores' do
        expect(subject.rating.count).to eq(3)
        expect(subject.rating.values).to all( eq 0 )
      end
    end

    context 'with a hash of IP scores given' do
      let(:subject) { described_class.new ip_scores_hash }

      it 'creates a corresponding rating' do
        expect(subject.rating.keys).to eq ip_scores_rating.keys
      end
    end
  end

  describe '.load' do
    context 'with valid ip scores filename given' do
      let(:subject) { described_class.load ip_scores_filename }

      it 'loads a corresponding rating' do
        expect(subject.rating.keys).to eq ip_scores_rating.keys
      end
    end
  end

  describe '#up' do
    let(:subject) { ip_scores.up ip }

    it 'increases the IP score' do
      expect { subject }.to change { ip_scores.rating[ip] }.by 1
    end
  end

  describe '#down' do
    let(:subject) { ip_scores.down ip }

    it 'decreases the IP score' do
      expect { subject }.to change { ip_scores.rating[ip] }.by -1
    end
  end

  describe '#save' do
    let(:ip_scores_file) { Tempfile.new('ip_scores.csv') }
    let(:subject) { ip_scores.save ip_scores_file.path }

    let :result do
      "2.2.2.2,1\n1.1.1.1,0\n3.3.3.3,-1"
    end
    let :result2 do
      "1.1.1.1,3\n2.2.2.2,1\n3.3.3.3,-1"
    end

    after do
      ip_scores_file.unlink
    end

    it 'stores rating to a given file' do
      subject
      expect(File.read(ip_scores_file.path))
        .to match /#{Regexp.quote(result)}/m
    end

    it 'rewrites mutual ip scores' do
      subject
      ip_scores2.save ip_scores_file.path
      expect(File.read(ip_scores_file.path))
        .to match /#{Regexp.quote(result2)}/m
    end
  end
end
