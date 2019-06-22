# MetaHash

Here is a ruby library for interacting with the [#MetaHash](https://metahash.org/ "#MetaHash | Fast, secure, decentralized cryptocurrency") protocol/network.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'meta_hash'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install meta_hash

## Usage

### MetaHash::Key

Generate a new #MetaHash key:

```ruby
key = MetaHash::Key.generate
```

Read and write a passphrase secured private key from file:

The second argument with passphrase is optional.

If the key is password protected when reading and passphrase is omitted, it will
be requested from STDIN.

```ruby

key = MetaHash::Key.read(
  '~/.metahash_wallets/_unregistered/mhc/0x0123456789abcdef0123456789abcdef0123456789abcdef01.ec.priv',
  'passphrase',
)

key.write(
  "#{key.addr}.ec.priv",
  'passphrase',
)
```

To get plain public and private keys use:

```ruby
key.priv                         # private key in DER hex
key.priv :der                    # for binary string

key.pub                          # public key in DER hex
key.pub :der                     # for binary string
```

Computes an address from a key:

```ruby
key.addr
```

Data signing and signature verification:

```ruby
sig = key.sign('data')                           # sign data

public_key = MetaHash::Key.from_der key.pub :der # get public key from private key
public_key.verify('data', sig)                   # verify data signature
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CyJimmy264/meta_hash.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Donate

MHC: 0x0031337c35f8e7a3b3acb3952bc126a3493a40959d0a6c5a5f\
XLM: GAH7RJ3T76NNYUL3HBJD4DPTC54LVQA7CFYPC5MSDCY4GA3ZDRSOWLHF\
LTC: LZ8fSQ7skBwK7CeU8TJFy5VykhE3H5R1ZQ\
BCH: bitcoincash:qrxe7uq97pvjx066s97xc58tzvw3xwmknc88fppf4w

