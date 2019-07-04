RSpec.describe MetaHash do
  it 'has a version number' do
    expect(MetaHash::VERSION).not_to be nil
  end

  describe '.config.some_setting in conjunction with .configure' do
    let(:subject) { described_class.config.some_setting }

    context 'when has not been set' do
      it { is_expected.to be_nil }
    end

    context 'when set with "some value"' do
      before do
        MetaHash.configure do |c|
          c.some_setting = 'some value'
        end
      end

      after do
        MetaHash.configure do |c|
          c.some_setting = nil
        end
      end

      it { is_expected.to eq 'some value'}
    end
  end
end
