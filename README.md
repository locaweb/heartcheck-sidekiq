# Heartcheck::Sidekiq

A plugin to check sidekiq connection with heartcheck

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heartcheck-sidekiq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heartcheck-sidekiq

## Usage

You can add a check to sidekiq when configure the heartcheck

```ruby
Heartcheck.setup do |config|
  config.add :sidekiq do |c|
    c.name = 'redis'
  end
end
```

## Contributing

1. Fork it ( https://github.com/locaweb/heartcheck-sidekiq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
