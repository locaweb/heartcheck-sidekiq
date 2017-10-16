# Heartcheck::Sidekiq

[![Build Status](https://travis-ci.org/locaweb/heartcheck-sidekiq.svg)](https://travis-ci.org/locaweb/heartcheck-sidekiq)
[![Code Climate](https://codeclimate.com/github/locaweb/heartcheck-sidekiq/badges/gpa.svg)](https://codeclimate.com/github/locaweb/heartcheck-sidekiq)
[![Ebert](https://ebertapp.io/github/locaweb/heartcheck-sidekiq.svg)](https://ebertapp.io/github/locaweb/heartcheck-sidekiq)

##A plugin to check sidekiq connection with [heartcheck](https://github.com/locaweb/heartcheck).

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

You can check any sidekiq connection that there's in your app.

```ruby
Heartcheck.setup do |config|
  config.add :sidekiq do |c|
    c.name = 'redis'
  end
end
```
### Check Heartcheck example [here](https://github.com/locaweb/heartcheck/blob/master/lib/heartcheck/generators/templates/config.rb)

## License
* [MIT License](https://github.com/locaweb/heartcheck-sidekiq/blob/master/LICENSE.txt)

## Contributing

1. Fork it ( https://github.com/locaweb/heartcheck-sidekiq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
