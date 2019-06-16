RSpec.describe MetaHash::Key do
  let(:metahash_key) { MetaHash::Key.generate }
  let(:passphrase) { 'passphrase' }

  context '.generate' do
    let(:result) { MetaHash::Key.generate }

    it 'generates a #MetaHash key' do
      expect(result).to be_instance_of MetaHash::Key
      expect(result.pkey).to be_instance_of OpenSSL::PKey::EC
    end
  end

  context 'with sample private key file' do
    let(:metahash_key_addr) do
      '0x000cda577c79bc9920b4416e1b384612602896795ab654b8fb'
    end
    let(:private_key_filename) do
      "spec/fixtures/keys/#{metahash_key_addr}.ec.priv"
    end
    let(:metahash_key) { MetaHash::Key.read private_key_filename, passphrase }

    let(:openssl_priv_hex) do
      # openssl ec -in spec/fixtures/keys/0x000cda577c79bc9920b4416e1b384612602896795ab654b8fb.ec.priv -passin pass:passphrase -outform DER 2>&/dev/null | xxd -p

      "307402010104207ec934ddc5dbc123dff6ff32222e7888bb7a07f97d61c4" +
        "daff06762c9113ef78a00706052b8104000aa14403420004ee245093cada" +
        "008580d0ced2a1d9e8562dc5160705fea2cbea2229ff47f67b505cca26be" +
        "fbcee5fa4829c124254f6dd00c4de180bc948dd3ebf7c701a8c5fd5c"
    end

    let(:openssl_priv) do
      #!ruby `openssl ec -in spec/fixtures/keys/0x000cda577c79bc9920b4416e1b384612602896795ab654b8fb.ec.priv -passin pass:passphrase -outform DER`.bytes

      [
        48, 116, 2, 1, 1, 4, 32, 126, 201, 52, 221, 197, 219, 193, 35, 223, 246,
        255, 50, 34, 46, 120, 136, 187, 122, 7, 249, 125, 97, 196, 218, 255, 6,
        118, 44, 145, 19, 239, 120, 160, 7, 6, 5, 43, 129, 4, 0, 10, 161, 68, 3,
        66, 0, 4, 238, 36, 80, 147, 202, 218, 0, 133, 128, 208, 206, 210, 161,
        217, 232, 86, 45, 197, 22, 7, 5, 254, 162, 203, 234, 34, 41, 255, 71,
        246, 123, 80, 92, 202, 38, 190, 251, 206, 229, 250, 72, 41, 193, 36, 37,
        79, 109, 208, 12, 77, 225, 128, 188, 148, 141, 211, 235, 247, 199, 1,
        168, 197, 253, 92
      ]
    end

    let(:openssl_pub_hex) do
      # openssl ec -in spec/fixtures/keys/0x000cda577c79bc9920b4416e1b384612602896795ab654b8fb.ec.priv -passin pass:passphrase -outform DER -pubout 2>&/dev/null | xxd -p

      "3056301006072a8648ce3d020106052b8104000a03420004ee245093cada" +
        "008580d0ced2a1d9e8562dc5160705fea2cbea2229ff47f67b505cca26be" +
        "fbcee5fa4829c124254f6dd00c4de180bc948dd3ebf7c701a8c5fd5c"
    end

    let(:openssl_pub) do
      #!ruby `openssl ec -in spec/fixtures/keys/0x000cda577c79bc9920b4416e1b384612602896795ab654b8fb.ec.priv -passin pass:passphrase -outform DER -pubout`.bytes

      [
        48, 86, 48, 16, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 5, 43, 129, 4, 0,
        10, 3, 66, 0, 4, 238, 36, 80, 147, 202, 218, 0, 133, 128, 208, 206, 210,
        161, 217, 232, 86, 45, 197, 22, 7, 5, 254, 162, 203, 234, 34, 41, 255,
        71, 246, 123, 80, 92, 202, 38, 190, 251, 206, 229, 250, 72, 41, 193, 36,
        37, 79, 109, 208, 12, 77, 225, 128, 188, 148, 141, 211, 235, 247, 199,
        1, 168, 197, 253, 92
      ]
    end

    let(:data) { 'test' }

    context '.read' do
      let(:result) { MetaHash::Key.read private_key_filename, passphrase }

      it 'reads encrypted private key from file' do
        expect(result).to be_instance_of MetaHash::Key
        expect(result.pkey).to be_instance_of OpenSSL::PKey::EC
      end
    end

    context '#priv' do
      context 'with hex form' do
        let(:result) { [metahash_key.priv, metahash_key.priv(:hex)].sample }

        it 'gets private key in DER hex form' do
          expect(result).to eq openssl_priv_hex
        end
      end

      context 'with bin form' do
        let(:result) { metahash_key.priv :der }

        it 'gets private key in plain DER form' do
          expect(result.bytes).to eq openssl_priv
        end
      end
    end

    context '#pub' do
      context 'with hex form' do
        let(:result) { [metahash_key.pub, metahash_key.pub(:hex)].sample }

        it 'gets public key in DER hex form' do
          expect(result).to eq openssl_pub_hex
        end
      end

      context 'with bin form' do
        let(:result) { metahash_key.pub :der }

        it 'gets public key in plain DER form' do
          expect(result.bytes).to eq openssl_pub
        end
      end
    end

    context '#addr' do
      let(:result) { metahash_key.addr }

      it 'computes address' do
        expect(result).to eq metahash_key_addr
      end
    end


    context '#sign' do
      let(:result) { metahash_key.sign data }

      it 'computes signature' do
        expect(result).to be_instance_of String
        expect(result).not_to be_empty
      end
    end

    context '#verify' do
      let(:public_key) { MetaHash::Key.from_der metahash_key.pub :der }
      let(:signature) { metahash_key.sign data }

      let(:another_key) { MetaHash::Key.generate }
      let(:another_public_key) { MetaHash::Key.from_der another_key.pub :der }
      let(:another_signature) { another_key.sign data }

      let(:result)         { public_key.verify         data, signature }
      let(:another_result) { another_public_key.verify data, another_signature }
      let(:mixed_result1)  { another_public_key.verify data, signature }
      let(:mixed_result2)  { public_key.verify         data, another_signature }

      it 'verifies the signature of the data of the same key' do
        expect(result).to be true
        expect(another_result).to be true
      end

      it 'does not verify the signature of the data of the different key' do
        expect(mixed_result1).to be false
        expect(mixed_result2).to be false
      end
    end
  end

  context '#write' do
    let(:private_key_file) { Tempfile.new('ec.priv') }
    let(:result) { metahash_key.write private_key_file.path, passphrase }

    after do
      private_key_file.unlink
    end

    it 'writes encoded private key' do
      result
      expect(File.read(private_key_file.path))
        .to match /EC PRIVATE KEY.*ENCRYPTED.*AES-128-CBC.*END/m
    end
  end
end
