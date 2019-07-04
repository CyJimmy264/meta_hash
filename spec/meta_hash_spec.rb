RSpec.describe MetaHash do
  it 'has a version number' do
    expect(MetaHash::VERSION).not_to be nil
  end

  describe '.config in conjunction with .configure' do
    let(:subject) { described_class.config }

    context 'with non existing setting' do
      it 'should be nil' do
        expect(subject.some_setting).to be_nil
      end
    end

    context 'with set some_setting' do
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

      it 'should be as configured' do
        expect(subject.some_setting).to eq 'some value'
      end
    end
  end
end
