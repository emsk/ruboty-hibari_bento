# Ruboty::HibariBento

Ruboty handler to get information of Hibari Bento, the bento shop in Ruby City MATSUE.

https://www.facebook.com/pages/ひばり弁当/1585734291650119

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruboty-hibari_bento'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruboty-hibari_bento

## Usage

Fetch new posts from the Hibari Bento Facebook page.

```
> ruboty bento pull
> ruboty bento fetch
> ruboty bento show
```

You can specify the number of posts.

```
> ruboty bento pull 1
> ruboty bento fetch 2
> ruboty bento show 3
```

Have a nice lunch!!

## ENV

```
HIBARI_BENTO_FACEBOOK_ACCESS_TOKEN - Facebook API access token
REDIS_URL      - Redis URL (e.g. redis://:p4ssw0rd@example.com:6379/)
REDISCLOUD_URL - Redis URL of Redis Cloud
REDISTOGO_URL  - Redis URL of Redis To Go
```

## Contributing

1. Fork it ( https://github.com/emsk/ruboty-hibari_bento/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
